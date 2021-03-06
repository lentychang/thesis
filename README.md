# Thesis in University of Applied Science Ravensburg Weingarten 
Work content belongs to IWT Wirtschaft und Technik GmbH

The more detailed info, please go to related repos mentioned below.

**Currently, the alignment method is down due to upgraded package PythonOCC in conda unofficial chanel.**  

## Introduction
This work tries to improve the object localization accuracy from 3D camera  in robotic assembly tasks by integrating/fusing the initial object localization result from 3D camera into the assembling knowledge in simulation. 

![Senario](https://raw.githubusercontent.com/lentychang/thesis/master/etc/Illustration_Lf064.png)

## Method  
The initial object localization result from each object is taken as an input, which applys to the correspondent 3D models as their initial poses in simulation.
By assumming that if the position patterns of the holes on two parts are close, they should be algined with each other in order to screw them.




## Future work
1. Active Extrinsic constraints localization: Localize objects by using gripper as locating fixture.
2. ML,DL to learn to find grasp point for locating components.
3. Try to combine with Computer Aided Assembly Planning, VR assembly planning.
4. Geometry extraction from CAEX, or PLM.ERP system
5. ML or DL? to learn the assembly knowledge, how to choose a better or reasonable geometric constraint.
6. 3D reconstruction from point cloud


## Claim
This works depends on some open-source packages. However, I didn't check in detailed, which kind of licenses are used.

## Introduction fo submodules
- **rel_pose_ext**:  
  Algorithm for STEP file geometry extraction and 3D model assembly-alignment 
- **bringups**:  
  dockerfiles for environment setup  
  - ros-base: base image for roscore
  - moveit: Using move group to control robot arm, RViz installed.
  - gazebo: Simulation env
  - pythonocc: Algorithm of my thesis
  - kinect2: get point cloud from kinect v2 into ros
  - pcl: simple FPFH object recognition pipeline, not tuned, bad performance

- **all_msgs**: all ros self-defined msgs
- **sim_device**: 
  all simulation related packages
  - iiwa_stack
  - wsg50_ros_pkg: schunk gripper
  - depth_sensors: simulated kinetic sensor
  - thesis: main launch file
  - thesis_moveit_config: control robot arm kuka iiwa7
  - thesis_visualization: visualize result in RViz, with markers

### Installation & Usage
1. `sudo bash ./install.sh`  
**Installation will take at least 3 hours on a Lenovo T430 ( CPU : i5 3rd gen, 4-threads )**  
It is an interactive shell script, please enter the location you want to download package  
2. Download [Model](https://drive.google.com/file/d/1hu24fzK6UWyHuMvjTJyuWSYJhqoMSfFP/view?usp=sharing), if wget failed to download file in the above bash scipt.
2. Launch environment  
After installation, go to <CATKIN_WORKSPACE>/src/thesis/bringups and execute `docker-compose up` 

**If you fail to launch...**
   - it might be *.launch files has no execution permission 
   - model or source code is put to the wrong direction. check the mounted of host in the docker-compose.yml file.



### Demo Run
The command to add model in gazebo will be upated in the comming weeks.  


There are at most 7 componets in the Bin.  
After adding at least two components, the later one will align with the first one, and is shown in rViz with marker with other color.
```bash
// add a model to gazebo 
// and add a marker (visual model) to rviz
rosservice call /addModelSrv
```


# TODO  
- Add Links
- Check license
- Add references
- Submodulize or fork all open-source repos: iiwa_stack, schunk50_ros_package, libfreenect2...
- Install, setup, data prepare shell script
- docker setup script
- Structure diagram

# References
