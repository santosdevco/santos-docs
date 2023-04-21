# Python Aptitude Test
Questions and answers

1. Which statement about class methods is true?
    - A class methos is a regular funciton that belongs to  a class, but it must return None
    -  A class method is a similar to an regular funcion, but a class method does not take any arguments.
    - [x]  A class method can modify the state of the class, but it cannot directly modify the state of an instance of that class
    - A class method holds all of the data for a particular class.



2. Which statement about static class methods is true?
    - Static  methods can be bound  to either  a class or an instance of a class.
    - [x] Static class methods serve mostly as utility  or helper methods, since they  cannot  access  or modify  a class's state.
    - Static class methods can access  and modify  the state of a class  or an instance  of a class.
    - Static class methods are called static because  they  always return None.

3. How does `defaultdict`  work?
    - [x] if you try to read  from `defaultdict` with a  noneexistent key,  a new default key-value pair will be  created  for you  instead throwing  a `KeyError`.
    - `defaultdict` stores  a copy of a dictionary  in memory  that you  can default  to if  the original  gets unintentionally  modified.
    - `defaultdict` will automatically create a dictionary  for you  that has  keys  wich are  the integers  0-10.
    - `defaultdict` forces a dictionary  to only  accept keys  that are  of the data  type  specified  when  you created  the `defaultdict` (such as strings  or    integers).
4. What is  the correct  syntax  for creating  a variable  that bound a set?
    - [x] `#!python my_set = {0, 'apple',3.5}`
    - `#!python my_set = to_set(0, 'apple',3.5)`
    - `#!python my_set = (0, 'apple',3.5).set()`
    - `#!python my_set = (0, 'apple',3.5).to_set()`

5. What is an abstract class?
    - Abstract  classes  must  be redefined any time  an object  is instantiated  from  them.
    - [x] An  Abstract  class exist only  so that  other  "concrete" classes can  inherit  from  the  abstract class.
    - Abstract  classes  must inherit  from concrete classes.
    - An  Abstract  class is the name  for any class  from which  you can instantiate  an object.

6. What is the purpose of the pass statement in Python?

    - It is used to skip the yield statement of a generator and return a value of None.
    - [x] It is a null operation used mainly as a placeholder in functions, classes, etc.
    - It is used to pass control from one statement block to another.
    - It is used to skip the rest of a while or for loop and return to the start of the loop.

7. What is the diference between class attributes and instance atributes
    - Class attributes belong just  to the class , not  to instances  of that class. Instance  attributes  are shared among  all instances  of  a class.
    - Class attributes 