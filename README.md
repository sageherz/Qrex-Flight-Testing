# Qrex-Missions
Repository containing codes and directions on how to create mission files for Qrex. There are two codes required to create mission files: ```qrexMissionWrapper_2.mat``` and ```writeMission_2.mat``` (both are included for download in this repository). 

## Creating a Mission File
To create a mission file, call the function ```qrexMissionWrapper_2``` and fill all function fields. A description of the fields are as follows: 
  * ```savePath```: Path to save file to
  * ```fileName```: Name for mission file
  * ```homePosition```: Home position for mission in latitude and longitude (ex: ```[39.795753, -83.065037]```). Typically, use the center of your desired flight path as the home position.
  * ```legAltitude```: Altitude for each leg of the mission in meters (ex: if you have three flight legs all at 10 meters, ```[10, 10, 10]```).
  * ```legHeading```: Heading of vehicle for each flight leg with respect to North and clockwise rotations are positive, in degrees (ex: North = 0°, East = 90°, South = 180°, West = 270°).
  * ```headingOffset```: Angular offset from heading for each flight leg in degrees (rotation about body z-axis), where CW rotation is positive and CCW is negative (ex: flying vehicle at three angles: ```[-45, 0, 45]```).
  * ```legSpeed```: Speed of vehicle for each flight leg in m/s (ex: flying vehicle at three speeds: ```[5, 10, 15]```). 
  * ```legLength```: Length of each flight leg in meters. Typically the length on the flight leg is determined such that each leg lasts 30 seconds.
  * ```legHoldTime```: Time vehicle will hold at each waypoint at the end of each flight leg in seconds. Typically do about 10 second holds, unless longer hover times are desired.

Below is an example of how to generate the mission file included in the repository. This mission is located at the Columbus Aero RC Club. The runway of this area goes NE to SW, so the heading of the vehicle is set to 45° for each flight leg. The mission plan includes 6 flight legs that are as follows: 
 1. Vehicle flown at altitude of 10 m, heading offset of 0°, speed of 10 m/s, leg length of 300 m (~30 second leg), and hold time of 10 s.
 2. Same as #1, changing altitude to 15 m.
 3. Same as #1, changing heading offset to +45°.
 4. Same as #1, changing speed to 15 m/s.
 5. Same as #1, changing leg length to 200 m (~20 seconds).
 6. Same as #1, changing hold time to 20 seconds.

To call the function to create this mission file, type into the command line:
```
qrexMissionWrapper_2("Mission Files\","mission_test_file.plan",[39.795753, -83.065037],[10,15,10,10,10,10],[45,45,45,45,45,45],[0,0,45,0,0,0],[10,10,10,15,10,10],[300,300,300,300,200,300],[10,10,10,10,10,20])
```

(Make sure when calling the function, you are in the same folder where ```qrexMissionWrapper_2.mat``` and ```writeMission_2.mat``` are located, or have added a path to them in your workspace.)
