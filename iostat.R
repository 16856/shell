library(data.table)
library(lubridate)

# Load data.table colnames
iostat_header <- read.table('../log/IOSTAT_HEADERS.log', header=TRUE)

# Read statistics data.
iostat <- fread('../out/iostat.out', col.names=names(iostat_header))

head(iostat)
iostat[,D:=ymd_hms(Datetime)][5,]