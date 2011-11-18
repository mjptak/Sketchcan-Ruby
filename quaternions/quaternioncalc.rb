model = Sketchup.active_model
entities = model.entities
selection = model.selection
definitions=model.definitions
view=model.active_view

def quatmult(a,b)
# this routine was crafted to mimic the quaternion rotations which
# sketchup presumably uses to manage transformations.  It uses
# hamiltonian numbers in the form of [real,[vector]]
# for rotations the number takes the form [cos(angle/2),sin(angle/2)[axis vector]]
# for points the number takes the form of 
#[radial vector magnitude from origin to point,[unit vector direction]]
# the first value is the quaternion and the second is the point
   c=[0,[0,0,0]]
    c[0]=a[0]*b[0]-a[1][0]*b[1][0]-a[1][1]*b[1][1]-a[1][2]*b[1][2]
    c[1][0]=a[0]*b[1][0]+a[1][0]*b[0]+a[1][1]*b[1][2]-a[1][2]*b[1][1]
    c[1][1]=a[0]*b[1][1]-a[1][0]*b[1][2]+a[1][1]*b[0]+a[1][2]*b[1][0]
    c[1][2]=a[0]*b[1][2]+a[1][0]*b[1][1]-a[1][1]*b[1][0]+a[1][2]*b[0]
    return c
    end

def quatrot(e,f)
#this routine applies a sandwich product between a quaternion rotation and 
#a point.  NOTE:  extra code is required to set the original quaternion back
#from its conjugate.  Need to make it less hacky
    g=quatmult(e,f)
    h=[]
    h.push(e[0])
    h.push(e[1])
    h[1][0]=-h[1][0]
    h[1][1]=-h[1][1]
    h[1][2]=-h[1][2]
    l=quatmult(g,h)
    h[1][0]=-h[1][0]
    h[1][1]=-h[1][1]
    h[1][2]=-h[1][2]
    return l
    end

def torad(a)
#this unnecessary routine converts from degrees to radians
    a=a*Math::PI/180.0
    return a
    end


#this is the main code
#the next lines define the axis and angle of rotation
dec=90-23.4
ra=0
rotangl=15
dec=torad(dec)
ra=torad(ra)
rotangl=torad(rotangl)

#define a dummy quaternion and then fill in the rotation quaternion
#based on angular definitions.  Should probably make it a function.
q=[0.9659,[0,0,0.2588]]
q[0]=Math.cos(rotangl/2.0)
q[1][0]=Math.sin(rotangl/2.0)*Math.cos(dec)*Math.cos(ra)
q[1][1]=Math.sin(rotangl/2.0)*Math.cos(dec)*Math.sin(ra)
q[1][2]=Math.sin(rotangl/2.0)*Math.sin(dec)


#These lines are here to demonstrate combinations of quaternions
#quaternion combination is communative and a simple multiplication
#q2=[0.99144,[0,0,-0.13053]]
#q=quatmult(q,q2)







#p defines the quaternion for the initial insertion point
p=[0,[0,1,0]]
entities.add_instance(definitions[0],p[1])

for i in 1..24
    e=quatrot(q,p)
    p=e
    entities.add_instance(definitions[0],e[1])
    newview=view.refresh
    sleep 0.1
end

#this section of code uses the standard Google Sketchup API to do rotations
#the definition is essentially the same with a transformation defined by
#a center point, an axis and and angle  Note: Check what happens when you multiply
#transformations since they are stored as 16 place arrays.

trans=Geom::Transformation.new([0,0,0],[Math.cos(torad(90-23.4)),0,Math.sin(torad(90-23.4))],torad(5))

for i in 1..480 do
    entities.each{|e|
        entities.transform_entities(trans,e)
    }
    newview=view.refresh
    sleep 0.01
end
