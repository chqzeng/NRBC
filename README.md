# NRBC (Ongoing project)
A Natural-Rule-Based-Connection (NRBC) Method for River Network Extraction from High-Resolution Imagery  

Please cite this work as:  
Zeng, C.; Bird, S.; Luce, J.J.; Wang, J.	A Natural-Rule-Based-Connection (NRBC) Method for River Network Extraction from High-Resolution Imagery. Remote Sens. 2015, 7, 14055-14078.

### Introduction of the water body detection software package (NRBC). 

This is a group of Matlab functions to detect and connect water body from satellite/airborne imagery.  
The entire task is broken down into several relatively independent tasks, 
with the most important part NRBC published and can be open accessed 
[Here] (http://www.mdpi.com/2072-4292/7/10/14055).


The overall river detection task is broken down as:  

1.  Unsupervised classification of satellite imagery: (here we are using 8 band original Worldview-2 imagery)
 With the unsupervised classification result, the water clusters (classes) are automatically/adaptively chosen from all classes.  
  -->  **[Viusalize_of_Centres]** module is designed for this purpose  
  
2.  When a refined water body is achieved, we need to further connect river segments to form topologically correct/completed rivers.
  This is a complicated stage with many steps. A image pyramid is generated, and topology at top level  (downsampled imagery) is then deliver to the bottom level (original resolution imagery)
  Many rules are applied to test the potential connect-able  river segments., such as the river direction and width consistence between neighbouring river segments.
  finally the gap is filled if it is a successful/ connect-able case.    
  --> **[River_Patch_Connection]** module is designed for this task with many functions.  
 
3.  After a complete water body, with complete/correct rivers been connected, is generated, the centerline of the rivers are generated.
  An improved morphological method that first skin the water mask and then remove the spurs is used.
  An alternative method is using the MEANSHIFT method, which is also implemented.  
  --> **[River_Centerline]** module is implemented for this purpose.  
  
4.  The bridge can also be detected after water body detection: bridges are detected, and regularized as rectangles 
  The main idea is find the river connected areas, as seed for potential bridge locations, and then use rule to remove incorrect case and process the correct case.  
    --> **[Bridge_Detection]** module is designed for this purpose.
  

There are some other isolated functions which are not used in this mainstream, but still quite useful for other applications.
 such as the Image pyramid construction,  non-linear fitting of points, etc.  
 
 __Removed section__   
5.  After the water classes are selected, a coarse water mask is generated.
  within this water mask, there are some mistaken areas, such as shadows, 
  to refine the result, a SAR (here we use the Radarsat-2 HH SLC image) image is used to refined the result
  We separate the water from non-water, by separating the overall histogram into two , 
  and a threshold is set appropriate to distinguish water from non-water by Mean backscatter value in SAR imagery
  --> **[Histogram_Separation]** package is designed for this purpose  
**Note**: this section is removed now.   
__Removed section__  

### Note    
 This entire project is for research purpose thus did not well-test. 
 They may be many issues/bugs when you run with own data, please report any problem or improvement suggestion to: chqzeng@gmail.com

