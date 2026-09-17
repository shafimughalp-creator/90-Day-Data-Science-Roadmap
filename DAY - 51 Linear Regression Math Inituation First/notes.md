# Linear Regression — Math Intuition First

## Quick Overview
- **Topic:** The math underneath Linear Regression — the equation, the cost function, and gradient descent, built from scratch.
- **What I learned:** A trained model is just weights and a bias that gradient descent found by repeatedly asking "which direction reduces my error?" and taking a small step that way.
- **Tools used:** Python, NumPy (no scikit-learn today — implemented the model manually), Matplotlib.

## Introduction
Day 51 of the 90-Day Data Science Roadmap, and the first day of Phase 4 that goes under the hood instead of calling `.fit()`. Every model I'll train from here on — logistic regression, neural networks, even boosted trees — leans on the same core idea: define a cost function, then use its gradient to walk downhill until the cost is as low as it can get.

I used FC Lahore Lions match data again: predicting **goals scored** in a match from **shots on target** and **possession %**, built the whole training loop myself with NumPy.

## Definitions
- **Linear regression equation:** `y = w1*x1 + w2*x2 + b` — each weight (`w1`, `w2`) says how much that feature moves the prediction; `b` (bias/intercept) is the baseline prediction when all features are zero.
- **Cost function (MSE):** the *Mean Squared Error* — average of `(y_pred - y_actual)²` across all examples. It's a single number that says "how wrong is the model, overall?"
- **Gradient descent:** an algorithm that repeatedly computes the slope (gradient) of the cost function with respect to each weight, then nudges the weights in the *opposite* direction of that slope — because the gradient points uphill, and we want to go down.
- **Learning rate:** how big a step gradient descent takes on each update. Too small = slow to converge. Too large = can overshoot the minimum entirely.

## Important Concepts
- **Why square the error instead of just using `(y_pred - y_actual)`?**
  - Squaring makes every error positive, so overestimates and underestimates don't cancel each other out.
  - Squaring also **penalizes large errors much more than small ones** — an error of 4 contributes 16 to the cost, not 4, which pushes the model to avoid big misses.
- **The cost function is a bowl.** For a single weight, plotting cost vs. that weight's value traces out a U-shaped curve (a parabola). The bottom of the bowl is the weight value that minimizes error — that's the "solution" gradient descent is searching for.
- **The gradient tells you which way is downhill.** At any point on the bowl, the gradient (derivative of MSE with respect to the weight) points toward increasing cost — so subtracting a fraction of it moves the weight toward the minimum.
- **Convergence isn't instant.** Early steps make big improvements; the cost drops fast at first, then flattens out as the weights approach the bottom of the bowl.

## Step-by-Step Explanation
1. Normalize the input features (`shots`, `possession`) so gradient descent doesn't take wildly different step sizes across features of different scales.
2. Start with weights and bias at zero, and make a first prediction — it's a flat, uninformed guess.
3. Compute the MSE cost of that first guess — a high number, since the model hasn't learned anything yet.
4. Compute the gradients: the partial derivative of MSE with respect to each weight and the bias.
5. Take a step: `weight = weight - learning_rate * gradient` for every weight and the bias.
6. Repeat steps 3–5 for many iterations (epochs), watching the cost fall each time, until it stops improving meaningfully.
7. Sweep one weight across a range of values (holding the others fixed) and plot cost vs. that weight — confirming the bowl shape and that the trained weight sits at the bottom.

## Examples
- **Before training (`w=[0, 0]`, `b=0`):** every prediction is 0, and the starting MSE is **36.45** — a huge average error since real goal counts are nowhere near zero.
- **After one gradient descent step:** MSE drops from 36.45 to **23.69** — a big jump, because the very first step corrects the most obvious mistake (predicting nothing at all).
- **After 500 epochs (full training):** the model converges to `w ≈ [1.12, 0.21]`, `b ≈ 5.85`, with a final MSE of **0.98** — shots on target ends up mattering roughly 5x more than possession, which matches the football intuition that shots convert to goals more directly than time on the ball.
- **Cost vs. weight sweep:** sweeping the "shots" weight from -2 to 4 while holding the rest fixed traces a clear bowl, bottoming out right at **w1 ≈ 1.10** — almost exactly where gradient descent converged on its own.

## Common Mistakes
- Forgetting to normalize/scale features — on unscaled data, gradient descent can take huge, unstable steps on the feature with the bigger range and barely move on the other.
- Picking a learning rate that's too large — the cost can bounce around or even increase instead of settling into the bowl.
- Assuming gradient descent is "done" after just a few epochs without checking whether the cost has actually flattened out.
- Confusing the bias term with "unimportant" — a nonzero bias here (≈5.85) reflects a real baseline (e.g. an average number of low-shot goals), not noise to ignore.

## Interview Questions
- **Q: Why do we square the error in MSE instead of using absolute error?**
  A: Squaring keeps errors non-negative (so they don't cancel out) and is differentiable everywhere, which makes it easy to compute gradients for gradient descent — absolute error has a sharp corner at zero that complicates that.
- **Q: What does the learning rate control, and what happens if it's too high?**
  A: It controls the step size on each gradient descent update. Too high, and the updates can overshoot the minimum and cause the cost to oscillate or diverge instead of converging.
- **Q: What does a weight of 0 in a trained linear regression model mean?**
  A: That feature has (close to) no linear relationship with the target once the other features are accounted for — it isn't contributing to the prediction.
- **Q: Why do we normalize features before gradient descent?**
  A: Features on very different scales create a cost surface that's a long, narrow valley rather than a symmetric bowl, which makes gradient descent slow or unstable. Normalizing puts all features on comparable scales.

## Key Takeaways
- Linear regression's equation is just a weighted sum plus a bias — the "learning" is finding the best weights.
- MSE squares the error so big mistakes are penalized more, and so the cost function stays smooth for gradient descent.
- Gradient descent works by repeatedly stepping opposite the gradient — downhill on the cost bowl — until it converges.
- Visualizing cost vs. a single weight makes an abstract optimization process into something you can literally see bottom out.

## Summary
Today was about building linear regression from first principles instead of calling `.fit()` — writing the prediction function, the MSE cost, the gradients, and the training loop by hand with NumPy. Watching the cost drop from 36.45 to under 1 over 500 epochs, and then confirming the trained weight sits exactly at the bottom of the cost bowl, made gradient descent feel mechanical rather than mysterious. This is the foundation every later model in the roadmap will build on.
