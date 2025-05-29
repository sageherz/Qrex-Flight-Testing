# Qrex Flight Testing
Repository containing codes and directions on how to create mission files for Qrex, connect to Raspberry Pi computers on both outdoor and indoor Qrex, and recording data files.

## Creating a Mission File
There are two codes required to create mission files: ```qrexMissionWrapper_2.mat``` and ```writeMission_2.mat``` (both are included for download in this repository). To create a mission file, call the function ```qrexMissionWrapper_2``` and fill all function fields. A description of the fields are as follows: 
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

## Pi Startup Commands -- Indoor Qrex (ROS2)
Below are the startup commands for the indoor Qrex vehicle:
* Connect to WiFi called "QRex_Indoor" (PW: "QRex_Indoor").
* Open PuTTY window using shortcut on flight laptop desktop or manually connecting (SSH) to 10.42.0.1 (username: pi, PW: raspberry).
* Start ROS node: ```ros2 launch serial_server qrex_launch_new.xml &```
* Many messages should populate on the screen and this is when it is good to open QGroundControl
   * Below are a few commands to be input in the MAVLink command console (navigate to the command window in QGC by clicking on icon in top left --> Analyze Tools --> MAVLink Console):
      * Stop internal magnotometer initializion: ```ist8310 stop```
      * Start external magnotometer: ```ist8310 start -X```
      * Check magnotometer status: ```ist8310 status```
      * Stop laser range finder: ```vl53l1x stop```
      * Initialize laser range finder and tell Pixhawk it is pointed horizontally (at wall/box): ```vl53l1x start -X -R 90```
      * Check status of laser range finder: ```vl53l1x status```
      * Start Mavlink debug message: ```px4_mavlink_debug &``` (This will start the publishing of "DEBUG_VECT" which will include the data from the ARK Flow sensor pointed at the ground and the laser range finder pointed at the wall. This data is live printed out in the "MAVLink Inspector" window.)
* Open a second PuTTY window.
* Navigate to where data files are stored: ```cd bag_files```
* If first flight of the day, create folder with today's date: ```mkdir YYYYMMDD```
* Navigate to newly created folder: ```cd YYYYMMDD```
* Some commands you may want to execute before starting data recording file to make sure all data is publishing:
   * Check list of published ROS topics: ```ros2 topic list``` (This will print out a list of all published ROS topics, of importance are ```/Qrex``` and ```/Pressure```.)
   * Visually inspect data publishing of a given topic: ```ros2 topic echo /Qrex``` (This will print out the data published by that topic to your screen.)
* Record data file (all topics recorded): ```ros2 bag record -a```

## Pi Startup Commands -- Outdoor Qrex (ROS1)
Below are the startup commands for the outdoor Qrex vehicle:
* Connect to WiFi called "Quad_Wifi" (PW: "Quad_Wifi").
* Open PuTTY window using shortcut on flight laptop desktop or manually connecting (SSH) to raspberrypi.local (username: pi, PW: raspberry).
* Initialize screen (in case you disconnect from window): ```screen```
* Start ROS node: ```roslaunch trims MavProp-udp.launch &```
* Many messages should populate on the screen and this is when it is good to open QGroundControl.
* Open a second PuTTY window.
* Initialize screen (in case you disconnect from window): ```screen```
* Navigate to where data files are stored: ```cd bag_files```
* If first flight of the day, create folder with today's date: ```mkdir YYYYMMDD```
* Navigate to newly created folder: ```cd YYYYMMDD```
* Some commands you may want to execute before starting data recording file to make sure all data is publishing:
   * Check list of published ROS topics: ```rostopic list``` (This will print out a list of all published ROS topics, of importance is ```/arm_4```.)
   * Visually inspect data publishing of a given topic: ```rostopic echo /arm_4``` (This will print out the data published by that topic to your screen.)
* Record data file (all topics recorded): ```rosbag record -a``` OR record data file (selected topics recorded): ```sh ~/bag_files/qrex-record.sh```
* If you disconnect from either PuTTY window, ```screen -rd``` will display all active screens (each with a number identifier), and you can reconnect by typing: ```screen -rd ###``` (where ### is the screen's number identifier). 

