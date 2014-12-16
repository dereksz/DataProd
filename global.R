cars <- mtcars
cars$transmission <- relevel(as.factor(ifelse(cars$am == 0, 'auto', 'manual')),'manual')
cars <- cars[,-9]
cars$cyl <- as.factor(cars$cyl) 
cars$gear <- as.factor(cars$gear)
cars$carb <- as.factor(cars$carb)
cars$vs <- as.factor(cars$vs)