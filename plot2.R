### 
### Download Data set
### Param boolean to download zip or not
###
plot2Setup <- function(download)
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
plot2ReadData <- function()
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
  
  return (dataset)
}

###
### Create plot and save to .png
###
plot2Render <- function(dataset)
{
  #Open gfx device
  png("plot2.png", width=480, height=480)
  
  #Plot
  plot(dataset$DateTime, dataset$Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)")
  
  #Close device
  dev.off()
}

###
### Main routine
###
plot2Run <- function(download = FALSE)
{
  #Prep Data
  plot2Setup(download)
  
  #Load data
  dataset <- plot2ReadData()
  
  #Render
  plot2Render(dataset)
}