# This function was created to standardize column names between two databases 
  # and then base::rbind the new df (the function doesn't work with diff cols)

# Steps:
  # 1. Add missing cols to dfs by setdiff ouput & nrows of other df
  # 2. Gsub `.` to `_` in df names 
  # 3. Use base::rbind to combine dfs
base_bind_rows <- function(df1, df2) {
  names_df1 <- lapply(names(df1), gsub, pattern = "\\.", replacement = "_")
  names_df1 <- unlist(names_df1)
  names(df1) <- names_df1
  
  names_df2 <- lapply(names(df2), gsub, pattern = "\\.", replacement = "_")
  names_df2 <- unlist(names_df2)
  names(df2) <- names_df2
  

  set_diff1 <- setdiff(names_df1, names_df2)
  set_diff2 <- setdiff(names_df2, names_df1)
  
  empty_df1 <- as.data.frame(matrix(ncol = length(set_diff2), nrow = nrow(df2)))
  names(empty_df1) <- set_diff2
  mdf1 <- merge(df1, empty_df1)

  empty_df2 <- as.data.frame(matrix(ncol = length(set_diff1)))
  names(empty_df2) <- set_diff1
  mdf2 <- merge(df2, empty_df2)
    

  all_rows <- rbind(mdf1, mdf2)
  # all_rows <- unlist(all_rows)
  names_all <- lapply(names(all_rows), gsub, pattern = "\\.", replacement = "_")
  names(all_rows) <-  unlist(names_all)
   
  return(all_rows)
}
