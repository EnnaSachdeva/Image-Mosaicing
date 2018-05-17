# Image-Mosaicing

Implementation of DLT	 (Direct	 Linear	
Transformation)	based	and	RANSAC	
based	 methods	 for	 estimating	 the	
homography	 between	 two	 images.	
Implementation	 of	 SIFT	
descriptor	to	find	as	many	matching	
points	 between	 two	 images	 as	
possible and then use the	 matches	 between	
two	 images	 to	 estimate	 the	
homography. With set of overlapping	images	
of	 a	 scene	 with	 the	 camera	 being	
held	 at	 the	 same	 location	 (camera	
center), use	 the	homography	 method	 to	 stich	 them	
together and create	 a	
single	panoramic	image.

Correct the perspective	 distortion by	 estimating	
the	 homography	 between images	and a	fronto-parallel	view	by	
manually	specifying	the	corners	of	a	rectangular	region	in	the	image.
