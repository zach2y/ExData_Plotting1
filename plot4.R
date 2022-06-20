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
png("plot4.png")

# Plot
par(mfrow=c(2,2))
with(power, plot(DateTime, Global_active_power, xlab = "", ylab="Global Active power", type="l"))
with(power, plot(DateTime, Voltage, xlab = "datetime", type="l"))
with(power, plot(DateTime, Sub_metering_1, xlab="", ylab="Energy sub metering", type="l"))
with(power, lines(DateTime, Sub_metering_2, xlab="", ylab="Energy sub metering", type="l", col="red"))
with(power, lines(DateTime, Sub_metering_3, xlab="", ylab="Energy sub metering", type="l", col="blue"))
legend("topright", lty=1, col=c("black", "red", "blue"), 
       legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty="n")
with(power, plot(DateTime, Global_reactive_power, xlab = "datetime", type="l"))

# Close the png file device
dev.off()