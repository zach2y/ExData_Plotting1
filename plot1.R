# Load libraries
library(data.table)
library(dplyr)
library(tidyr)

# Download and unzip file
if(!file.exists("./data")){dir.create("./data")}
url <-  "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
f <- file.path("./data", "exdata_data_household_power_consumption.zip")
if(!file.exists("./data/household_power_consumption.txt")){
        download.file(url, f) 
        unzip(f, exdir = "./data")
}

# Read data set
df <- as_tibble(fread("./data/household_power_consumption.txt",na = c("?", "NA", "")))

# Subsetting to dates 2007-02-01 and 2007-02-02
power <- subset(df, Date == "1/2/2007" | Date == "2/2/2007")

# Convert the Date and Time variables to Date/Time classes
power$Date <- as.Date(power$Date, "%e/%m/%Y")
power$DateTime <- strptime(paste(power$Date, power$Time), "%Y-%m-%d %H:%M:%S")
power <- select(power,Date, Time, DateTime, everything())

# Launch graphics device
png("plot1.png")

# Plot
with(power, hist(Global_active_power, col="red", xlab="Global Active Power (kilowatts)", 
                 main="Global Active Power"))

# Close the png file device
dev.off()
