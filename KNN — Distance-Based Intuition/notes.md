[day_56_knn_distance_intuition_notes.md](https://github.com/user-attachments/files/32570660/day_56_knn_distance_intuition_notes.md)
# Day 56: KNN — Distance-Based Intuition

## Quick Overview
- **Topic:** K-Nearest Neighbours (KNN): predicting by majority vote of the K closest training points.
- **What I learned:** KNN just stores data and measures distance, so the choice of K and feature scaling change results a lot.
- **Tools used:** Python, NumPy, pandas, Matplotlib, scikit-learn (`KNeighborsClassifier`, `StandardScaler`, `train_test_split`).

## Introduction
- KNN is one of the most intuitive ML algorithms: to classify a new item, look at the K most similar items you already know and go with the majority.
- It builds intuition for clustering and nearest-neighbour search later.
- Dataset: 300 synthetic FC Lahore Lions players (`seed = 42`) with `sprint_speed_kmh`, `minutes_played` and `is_winger` (1 = winger, 0 = centre back).
- `minutes_played` was deliberately made **unrelated** to the role, to show what happens when a large-scale feature dominates the distance.
- Split: 225 training rows, 75 test rows (`stratify=y`).

## Definitions
- **KNN:** a model that predicts using the classes of the K nearest training points.
- **K:** the number of neighbours that vote.
- **Neighbour:** a training point close to the new point.
- **Euclidean distance:** straight-line distance, `sqrt((x1 - x2)² + (y1 - y2)²)` for two features.
- **Majority vote:** the class that most of the K neighbours have.
- **Lazy learner:** a model with no real training phase. `.fit()` only stores the data.
- **Feature scaling:** putting features on a similar scale. `StandardScaler` uses `(value - mean) / std`.
- **Validation set:** a slice of the training data used to choose settings like K, so the test set stays untouched.

## Important Concepts
- **No training phase**
  - `.fit()` stores the training data. All the work happens when `.predict()` is called.
  - Prediction can get slow on big datasets, because every new point is compared with every stored point.
- **Euclidean distance**
  - Subtract each feature, square it, add them up, take the square root.
  - Checked by hand and with `np.linalg.norm`: both gave `300.004` for the same two players.
- **Effect of K**
  - K = 1: follows every single point. Train accuracy was 1.0 but test accuracy was only 0.60 (overfit).
  - Small-to-moderate K (3 to 9): best test accuracy here (0.75 to 0.76).
  - Large K: smoother model. Train accuracy fell to about 0.76 at K = 101, while test accuracy stayed about 0.76 on this simple, mostly one-feature pattern.
  - Use an odd K for two classes to avoid ties.
- **Feature scaling is critical**
  - Speed gap between two players: about 1.5 km/h, adding `2.25` to the squared distance.
  - Minutes gap: about 300 minutes, adding `90000`.
  - So unscaled KNN is basically "nearest by minutes played", which has nothing to do with the role.
- **Scale using training data only**
  - `fit_transform` on the training set, then `transform` on the test set (same leakage rule as Day 49).
- **Choosing K honestly**
  - Pick K on a validation split, not on the test set, and score the test set once at the end.

## Step-by-Step Explanation
- **KNN from scratch for one new player:**
  - Step 1: measure the distance from the new player to every training player.
  - Step 2: sort the distances and take the positions of the K smallest.
  - Step 3: look up the classes of those K players.
  - Step 4: the most common class is the prediction.
- **In sklearn:**
  - `KNeighborsClassifier(n_neighbors=5)` then `.fit(X_train, y_train)` then `.predict(new_data)`.
- **With scaling:**
  - `scaler.fit_transform(X_train)`, `scaler.transform(X_test)`, then fit KNN on the scaled data.

## Examples
- **Distance by hand:** players `(31.0, 1200)` and `(29.5, 1500)` are `300.004` apart. Speed adds 2.25, minutes adds 90000.
- **New player `(31.0 km/h, 1500 min)`:** the 5 nearest players were all class 0, so the vote gave 0. The from-scratch code and sklearn agreed.
- **Unscaled vs scaled** (same data, K = 5):

  | Version | Test accuracy |
  |---------|---------------|
  | Unscaled | 0.453 |
  | Scaled | 0.760 |

- **K comparison (scaled data):**

  | K | Train accuracy | Test accuracy |
  |---|----------------|---------------|
  | 1 | 1.000 | 0.600 |
  | 5 | 0.818 | 0.760 |
  | 25 | 0.742 | 0.720 |
  | 101 | 0.756 | 0.760 |

- **Practice check:** new player `(30, 1250)` was `150.01` from A, `250.01` from B and `650.0` from C. The minutes gap decided it.
- **Mini challenge:** best K on the validation split was 11 (validation accuracy 0.754), and the final test accuracy was 0.747.

## Common Mistakes
- Forgetting to scale features before using KNN.
- Fitting the scaler on all the data (or the test set) instead of only the training set.
- Choosing K by looking at the test score.
- Using an even K on a two-class problem and getting ties.
- Thinking `.fit()` "learns" something. For KNN it only stores the data.
- Reading one test accuracy on 75 rows as exact. Small test sets are noisy.
- Including irrelevant features. They add noise to every distance.

## Interview Questions
- How does KNN make a prediction?
- Why is KNN called a lazy learner?
- What is Euclidean distance? Write the formula.
- What happens with K = 1? With a very large K?
- Why is feature scaling critical for KNN?
- How would you choose K?
- Why use an odd K for binary classification?
- What are the downsides of KNN on large datasets?

## Key Takeaways
- KNN = find the K closest points, then take a majority vote.
- Distance is the whole algorithm, so the scale of every feature matters.
- K = 1 memorises the training data. Larger K smooths the model.
- On the same data, scaling moved test accuracy from 0.453 to 0.760.
- Choose K with a validation set, not the test set.

## Summary
- KNN has no training phase. It stores data and compares distances at prediction time.
- Euclidean distance is `sqrt(sum((x1 - x2)²))`, and unscaled features let the biggest numbers decide.
- K controls how wiggly or smooth the model is.
- Scaling is not optional for KNN.
- **Next: Day 57.** KNN with sklearn plus cross-validation for choosing K.
