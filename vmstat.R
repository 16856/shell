library(data.table)
library(lubridate)

# Load data.table colnames
vmstat_header <- read.table('../log/VMSTAT_HEADERS.log', header=TRUE)
iostat_header <- read.table('../log/IOSTAT_HEADERS.log', header=TRUE)

# Read statistics data.
vmstat <- fread('../out/vmstat.out', col.names=names(vmstat_header))
iostat <- fread('../out/iostat.out', col.names=names(iostat_header))


head(vmstat)
head(iostat)

vmstat[,D:=ymd_hms(D)][5,]
iostat[,D:=ymd_hms(Datetime)][5,]
