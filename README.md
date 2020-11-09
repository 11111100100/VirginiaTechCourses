# VirginiaTechCourses
A visualization of every VT course offered in the Fall 2019-2020 semester

The project consists of a few main parts:
- Gathering the data
- Formatting the data
- Visualizing the data

Data was gathered from [Virginia Tech's University DataCommons](https://udc.vt.edu/irdata/data/course_grades/grades) and downloaded as a CSV file, which is converted to a JSON file. In this repo, that file is stored as `grades.json`, which stores all 4,381 courses and the information assosiated with those courses.

Then the data is read and formatted using the Python script, `individual_class_creator.py`, which saves another JSON file of individual classes. Individual classes are considered to have the same value for the `"Subject"` and `"Course No."` fields. For example, the following two courses would be aggrigated into the same MATH-2204 object: `{"Subject":"MATH", "Course No.":2204, "Instructor":"Professor Joe", ...}` and `{"Subject":"MATH", "Course No.":2204, "Instructor":"Dr. Bill", ...}`. The result of these "individual classes" is stored in the `individual_classes.json` file. In total, there are 2,142 individual courses. 

The JSON file is then imported to a [Processing 3](http://processing.org/) sketch. Processing is "a flexible software sketchbook and a language" using Java to create visuals. Most of the processing sketch is just drawing shapes and text on the screen (you'll probobly be able to understand what the code is doing if you take a look at it). Currently, the `GradeDisplayAbsolute.pde` file creates a visual representation of every object inside of the `individual_classes.json` file and stores the corrisponding image file in a seperate file with the subject and course number as the file name ("MATH-2204.png").

Finally, [ffmpeg](https://ffmpeg.org/) is used to convert the 2,142 image files to a .mp4 video with adjustable fps rates.
