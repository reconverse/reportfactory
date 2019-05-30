# reportfactory 0.0.4

* `archive_reports()` allows the user to move reports older than a given date
  into a special folder inside `report_sources` called `_archive` that will
  automatically ignored when building reports. 
* `list_reports()` and `update_reports()` gain the `ignore_archive` argument,
  which defaults to TRUE

# reportfactory 0.0.3

* fix bug where reports with identical partial slugs will cause an error
  (See https://github.com/reconhub/reportfactory/issues/9)
* Add NEWS
