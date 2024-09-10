The objective of the exercise is to build an object detection algorithm using particle filters.

```

• Initialization involves choosing a position at x0, y0 and generating particles around this position with random Gaussian noise.
• Probability of particles being the object of interest is calculated using the formula f(x) = exp(-x^2 / (2 * sigma^2)).
• The probability is normalized to calculate the weights of each particle.
• Particles and weights are updated based on the calculated probabilities.
• Particles are iteratively sampled from the current set of particles, with higher weight particles more likely to be selected.
• A new set of particles is created with the same number of particles as the original set, with all positions set to zero.
• Gaussian noise with standard deviation noise_std is added to the new set of particles to introduce randomness.
• The estimated position of the tracked object is calculated as the average position of the resampled particles after adding noise.
• The x and y coordinates of the upper left corner of the box are calculated.
• The box's width and height are calculated using the insertShape function.
```


**Observations**
Changing sigma and noise gives us different results.
The smaller the values, the better results we get.
