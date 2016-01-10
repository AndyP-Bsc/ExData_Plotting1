### 
### Download Data set
### Param boolean to download zip or not
###
plot4Setup <- function(download)
{
  #download dataset if requested
  if (download==TRUE)
  {
    download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip","hpc.zip",mode="wb")
  }
  
  #create data directory
  if (!file.exists("datadir"))
  {
    dir.create("datadir")
  }
  
  #unzip dataset
  unzip("hpc.zip",exdir="./datadir")
}

###
### Read data and subset
###
plot4ReadData <- function()
{
  dataset <- read.csv("./datadir/household_power_consumption.txt", sep = ";", stringsAsFactors = FALSE)
  
  #convert date to date type
  dataset$DateAsDate <- as.Date(dataset$Date,"%d/%m/%Y")
  
  #filter to reduce volumes  
  filter <- dataset$DateAsDate==as.Date("01/02/2007","%d/%m/%Y") | dataset$DateAsDate==as.Date("02/02/2007","%d/%m/%Y")  
  
  #subset
  dataset <- dataset[filter,]  
  
  #create datetime
  dataset$DateTime <- strptime(paste(dataset$Date,dataset$Time), format="%d/%m/%Y %H:%M:%S")
  
  #set numeric type
  dataset$Global_active_power <- as.numeric(dataset$Global_active_power)
  
  dataset$Voltage <- as.numeric(dataset$Voltage)
  dataset$Global_reactive_power <- as.numeric(dataset$Global_reactive_power)
  
  dataset$Sub_metering_1 <- as.numeric(dataset$Sub_metering_1)
  dataset$Sub_metering_2 <- as.numeric(dataset$Sub_metering_2)
  dataset$Sub_metering_3 <- as.numeric(dataset$Sub_metering_3)
  
  return (dataset)
}

###
### Create plot and save to .png
###
plot4Render <- function(dataset)
{
  #Open gfx device
  png("plot4.png", width=480, height=480)
  
  #Plot 
  par(mfrow = c(2,2))
  with(dataset, 
       {
         plot(dataset$DateTime, dataset$Global_active_power, type="l", xlab="", ylab="Global Active Power")
         
         plot(dataset$DateTime, dataset$Voltage, type="l", xlab="datetime", ylab="Voltage")
         
         with(dataset, plot(DateTime, Sub_metering_1, type = "l", xlab="", ylab="Energy sub metering"))
         with(dataset, points(DateTime, Sub_metering_2, col = "red", type = "l"))
         with(dataset, points(DateTime, Sub_metering_3, col = "blue", type = "l"))
         legend("topright", lty = 1, bty="n", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))
         
         plot(dataset$DateTime, dataset$Global_reactive_power, type="l", xlab="datetime", ylab="Global_reactive_power")
       })
  
  #Close device
  dev.off()
}

###
### Main routine
###
plot4Run <- function(download = FALSE)
{
  #Prep Data
  plot4Setup(download)
  
  #Load data
  dataset <- plot4ReadData()
  
  #Render
  plot4Render(dataset)
}