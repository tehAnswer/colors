# coloRs

![](https://d2ffutrenqvap3.cloudfront.net/items/2S2F1i3l2k2Z2F081x0p/Screen%20Recording%202018-02-07%20at%2009.07%20PM.gif?v=1ceaa036)

**coloRs** is a ~basic~ **_minimalistic_** interactive bitmap editor that allow its users to generate text-made images through a small script language. 

# How To Use

To get this running in your local machine, first clone the repository. Then you have some options depending on what you want:

1. If you are in a hurry, build coloRs Docker image (`docker build .`). That would run the example showed above in the GIF.
2. If you have a script you want to try out, then you have two other options: 

```
$ rake colors[/Path/To/Script] 
  ...
$ ./bin/colors /Path/To/Script
  ...
```

## Languague

coloRs languague comes down to the following instructions:

| Command |   Attribute I  |    Attribute II   | Attribute III | Atributte IV |   Example   |                     Description                    |
|:-------:|:--------------:|:-----------------:|:-------------:|:------------:|:-----------:|:--------------------------------------------------:|
|    I    | Number of rows | Number of columns |       -       |       -      |  `I 10 10`  |        Specify the dimensions of the canvas.       |
|    C    |        -       |         -         |       -       |       -      |     `C`     | Clears the canvas by painting everything in white. |
|    S    |        -       |         -         |       -       |       -      |     `S`     |                 Prints the canvas.                 |
|    H    |  Start column  |     End Column    |      Row      |     Color    | `H 1 2 3 R` |  Draws a horizontal line given a few coordinates.  |
|    V    |     Column     |     Start Row     |    End Row    |     Color    | `V 2 3 6 L` |   Draws a vertical line given a few coordinates.   |
|    L    |       Row      |       Column      |     Color     |       -      |  `P 1 1 G`  |                Paints a given pixel.               |





