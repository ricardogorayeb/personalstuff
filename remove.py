import string
import os
  

for i in range(1,12):
    for j in range(1,31):
        #print ("{:02d}".format(i),"{:02d}".format(j))
        filename = "2022-{:02d}-{:02d}*.bit".format(i,j)
        print (filename)
        os.system ('rm -f %s' % filename)

    


