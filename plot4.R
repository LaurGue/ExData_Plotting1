library(dplyr)
library(lubridate)


# Creation of the working directory
if(!file.exists("~/data")){dir.create("~/data")}

# ZIP file recovery
urlFile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(urlFile, destfile="~/data/household_power_consumption.zip")

# Download date recovery
dateDownloaded <- date()

# Extracting data from the ZIP file
unzip("~/data/household_power_consumption.zip", exdir = normalizePath('~/data'))

# Data from unzip file
df <- read.table("~/data/household_power_consumption.txt", header = TRUE, sep=";", dec=",")

#Date and Time conversion
df$Date = as.Date(df$Date, "%d/%m/%Y")
t <- subset(df, ymd(Date) <= "2007-02-02" & ymd(Date) >= "2007-02-01")
temp <- paste(t$Date, t$Time)
t$Time<-strptime(temp, "%Y-%m-%d %H:%M:%S") 


# Factor conversion in Numeric
for(k in 3:9){
t[,k]<- as.numeric( sub(",", ".", t[,k]))
}

# PNG File Create with the Plot
png(filename = "plot4.png", width=480, height=480)
par(mfrow=c(2,2))
plot(t$Time,t$Global_active_power, type = "l", xlab ="", ylab = "Global Active Power")
plot(t$Time,t$Voltage, type="l", xlab="datetime",ylab = "Voltage")
plot(t$Time,t$Sub_metering_1, type="l", ylab = "Energy sub metering", xlab = "")
points(t$Time,t$Sub_metering_2,col="red", type="l")
points(t$Time,t$Sub_metering_3, col="blue",type="l")
legend("topright", col= c("black","red","blue"), legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), lty=1, bty="n")
plot(t$Time,t$Global_reactive_power, type="l", xlab="datetime", ylab = "Global_reactive_power")
dev.off()
