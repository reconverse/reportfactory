#' Compile one or several R Markdown reports
#'
#' @param factory The path to the report factory or a folder within the desired
#'   factory. Defaults to the current directory.
#' @param reports Either a regular expression (passed directly to `grep()`) that
#'   matches to the report paths you would like to compile or an integer/logical
#'   vector.  If `reports` is an integer or logical vector then a call of
#'   `compile_reports(factory, reports = idx)` is equivalent to
#'   `compile_reports(factory, list_reports(factory)[idx])`.
#' @param params A named list of parameters to be used for compiling reports,
#'   passed to `rmarkdown::render()` as the params argument. Values specified
#'   here will take precedence over default values specified in YAML headers of
#'   the reports. Note that the set of parameter is used for all compiled
#'   reports.
#' @param quiet A logical indicating if messages from R Markdown compilation
#'   should be displayed; `TRUE` by default.
#' @param timestamp A character indicating the date-time format to be used for
#'   timestamps. Timestamps are used in the folder structure of outputs. If
#'   NULL, the format format(Sys.time(), "%Y-%m-%d_T%H-%M-%S") will be used.
#'   Note that the timestamp corresponds to the time of the call to
#'   compile_reports(), so that multiple reports compiled using a single call
#'   to the function will have identical timestamps.
#' @param subfolder Name of subfolder to store results.  Not required but helps
#'   distinguish output if mapping over multiple parameters.  If provided,
#'   "subfolder" will be placed before the timestamp when storing compilation
#'   outputs.
#' @param ... further arguments passed to `rmarkdown::render()`
#'
#' @return Invisble NULL (called for side effects only).
#'
#'
#' @importFrom utils write.table
#' @export
compile_reports <- function(factory = ".", reports = NULL,
                            params = NULL, quiet = TRUE, subfolder = NULL,
                            timestamp = format(Sys.time(), "%Y-%m-%d_T%H-%M-%S"),
                            ...) {

  # force timestamp to evaluate as soon as function called - needed due to the
  # `Sys.time` call within the default argument
  force(timestamp)

  # get factory root, report_sources and output folders
  tmp <- validate_factory(factory)
  root <- tmp$root
  report_sources <- tmp$report_sources
  outputs <- tmp$outputs

  # get vector of reports to compile
  report_template_dir <- file.path(root, report_sources)
  report_sources <- file.path(report_template_dir, list_reports(root))
  if (!is.null(reports)) {
    if ((is.numeric(reports) && is.wholenumber(reports)) || is.logical(reports)) {
      report_sources <- report_sources[reports]
    } else {
      report_sources <- lapply(reports, grep, report_sources, value = TRUE)
      report_sources <- unique(unlist(report_sources))
    }
  }

  # report output folder
  report_output_dir <- file.path(root, outputs)
  params_to_print <- params

  # loop over all reports
  for (r in report_sources) {

    # pull yaml from the report
    yaml <- rmarkdown::yaml_front_matter(r)

    # If params are supplied, these are combined with any default parameters
    # that may be set in the report header.  Where there are overlaps preference
    # is given to those set here.  After much trial and error the current way
    # we facilitate this is to alter the yaml header and save this altered
    # version to a new file which we then compile.
    if (!is.null(params)) {
      p <- yaml$params
      if (is.null(p)) {
        params_input <- params
      } else {
        other_params <- p[!names(p) %in% names(params)]
        params_input <- append(params, other_params)
      }
      out_file <- file.path(report_template_dir, "_reportfactory_tmp_.Rmd")
      on.exit(file.remove(out_file), add = TRUE)
      change_yaml_matter(r, params = params_input, output_file = out_file)
      params_to_print <- params_input
    }

    # display just enough information to be useful
    relative_path <- sub(report_template_dir, "", r)
    relative_path <- sub("\\.[a-zA-Z0-9]*$", "", relative_path)
    message(">>> Compiling report: ", relative_path)
    if (!is.null(names(params_to_print))) {
      message(
          "      - with parameters: ",
          paste(names(params_to_print), params_to_print, sep = " = ", collapse = ", ")
      )
    }

    # create an additional subfolder if desired
    if (is.null(subfolder)) {
      output_folder <- file.path(
        report_output_dir,
        relative_path,
        timestamp
      )
    } else {
      output_folder <- file.path(
        report_output_dir,
        relative_path,
        subfolder,
        timestamp
      )
    }

    # render a report in a cleaner environment using `callr::r`.
    # the calls below are a little verbose but currently work (can simplify
    # later if we desire)
    if (is.null(params)) {
      callr::r(
        function(input, output_folder, quiet, ...) {
          rmarkdown::render(
            input,
            output_format = "all",
            output_dir = output_folder,
            envir = globalenv(),
            quiet = quiet,
            ...)
        },
        args = list(
          input = r,
          output_folder = output_folder,
          quiet = quiet,
          ...
        )
      )
    } else {
      callr::r(
        function(input, output_folder, out_file, quiet, ...) {
          rmarkdown::render(
            input,
            output_format = "all",
            output_file = out_file,
            output_dir = output_folder,
            params = NULL,
            envir = globalenv(),
            quiet = quiet,
            ...)
        },
        args = list(
          input = out_file,
          output_folder = output_folder,
          out_file = file.path(relative_path),
          quiet = quiet,
          ...
        )
      )
    }

    # make a copy of the report
    file.copy(r, output_folder)
  }

  message("All done!\n")

  invisible(NULL)
}
