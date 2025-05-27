# Qrex-Missions
Repository containing codes and directions on how to create mission files for Qrex. There are two codes required to create mission files: ```qrexMissionWrapper_2.mat``` and ```writeMission_2.mat``` (both are included for download in this repository). 

## Creating a Mission File
To create a mission file, call the function ```qrexMissionWrapper_2``` and fill all function fields. A description of the fields are as follows: 
  * ```savePath```: Path to save file to
  * ```fileName```: Name for mission file
  * ```homePosition```: Home position for mission in latitude and longitude (ex: ```[39.795753, -83.065037]```). Typically, use the center of your desired flight path as the home position.
  * ```legAltitude```: Altitude for each leg of the mission in meters (ex: if you have three flight legs all at 10 meters, ```[10, 10, 10]```).
  * ```legHeading```: Heading of vehicle with respect to North and clockwise rotations are positive, in degrees (ex: North = 0&deg, East = 90&deg, South = 180&deg, West = 270&deg).
  * ```headingOffset```
  * ```legSpeed```
  * ```legLength```
  * ```legHoldTime```
