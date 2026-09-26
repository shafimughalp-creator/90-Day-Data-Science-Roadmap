[Uploading day_58_decision_tree_entropy_information_gain_notes.md…]()
# Day 58: Decision Tree — Entropy & Information Gain Theory

## Quick Overview
- **Topic:** How a decision tree chooses its questions, using entropy and information gain.
- **What I learned:** Entropy measures how mixed a node is, and information gain tells the tree which split makes the groups cleanest.
- **Tools used:** Python, NumPy (`log2`), pandas, Matplotlib. One optional check with scikit-learn's `DecisionTreeClassifier`.

## Introduction
- Decision trees are the building block for Random Forest and XGBoost, so the split logic matters.
- Today is theory and hand calculation. Using sklearn's tree properly (and drawing it) is Day 59.
- Dataset: a 12-match FC Lahore Lions toy table with `shots` (High/Low), `home` (Yes/No) and `won` (Win/Loss). Six wins and six losses.
- The table is small on purpose, so every number can be checked by hand.

## Definitions
- **Decision tree:** a flowchart of yes/no questions that ends in a prediction.
- **Root node:** the first question, using all the data.
- **Decision node:** a question inside a branch.
- **Leaf node:** the end of a branch. It predicts the majority class.
- **Impurity:** how mixed the classes are inside a node.
- **Pure node:** all rows belong to one class.
- **Entropy:** `H = -Σ p · log₂(p)`, where `p` is the share of each class in the node.
- **Information gain (IG):** `entropy(parent) − weighted sum of entropy(children)`.
- **Weighted:** each child counts in proportion to how many rows it holds.

## Important Concepts
- **Tree structure**
  - Root, then decision nodes, then leaves.
  - Each node splits on one feature.
- **Entropy**
  - Pure node: `H = 0`.
  - Two classes split 50/50: `H = 1` (the maximum).
  - Anything in between is between 0 and 1. For example, 5 wins and 1 loss gives `H = 0.65`.
  - `0 · log₂(0)` is treated as 0, so pure nodes are fine.
  - Log base 2 is used, so entropy is measured in bits.
- **Information gain**
  - Measures how much a split reduces uncertainty.
  - Always weight the children by size. A tiny pure child should not count as much as a big one.
  - The tree picks the split with the highest gain, then repeats inside each branch.
- **Greedy splitting**
  - The tree only looks at the best split right now, not the best tree overall.
- **Stopping**
  - A node becomes a leaf when it is pure or there is nothing left to split on.
  - A leaf can still be impure (for example 2 wins and 1 loss). The prediction is then the majority class.
  - Splitting until every leaf is pure can overfit. Limiting depth comes in Day 59.

## Step-by-Step Explanation
- **Step 1:** Count the classes in the parent node (6 wins, 6 losses).
- **Step 2:** Calculate parent entropy: `−(0.5·log₂0.5 + 0.5·log₂0.5) = 1.0`.
- **Step 3:** For each candidate feature, split the rows and calculate each child's entropy.
- **Step 4:** Weighted child entropy = `Σ (child size / parent size) × child entropy`.
- **Step 5:** `IG = parent entropy − weighted child entropy`.
- **Step 6:** Pick the feature with the highest IG as the split.
- **Step 7:** Repeat inside each child using the remaining features until a stopping rule is met.

## Examples
- **Entropy checks:**
  - 6 wins, 0 losses: `0.0`
  - 3 wins, 3 losses: `1.0`
  - 5 wins, 1 loss: `0.650`
- **Split on Shots (by hand):**
  - High: 6 matches, 5 wins and 1 loss, `H = 0.650`
  - Low: 6 matches, 1 win and 5 losses, `H = 0.650`
  - Weighted = `(6/12)(0.650) + (6/12)(0.650) = 0.650`
  - **IG = 1.0 − 0.650 = 0.350**
- **Split on Home (by hand):**
  - Yes: 6 matches, 4 wins and 2 losses, `H = 0.918`
  - No: 6 matches, 2 wins and 4 losses, `H = 0.918`
  - Weighted = `0.918`
  - **IG = 1.0 − 0.918 = 0.082**
- **Root choice:** Shots (0.350) beats Home (0.082), so **Shots is the root**.
- **Second level:** inside Shots = High (5W 1L, `H = 0.650`), splitting on Home gives `IG = 0.191`. The Shots = Low branch also gives `0.191`.
- **Final tree:**
  - Shots High, Home Yes: Win (3W 0L)
  - Shots High, Home No: Win (2W 1L)
  - Shots Low, Home Yes: Loss (1W 2L)
  - Shots Low, Home No: Loss (0W 3L)
- **Practice:** parent 4W 4L, split into 3W 1L and 1W 3L. Each child has `H = 0.811`, so `IG = 1.0 − 0.811 = 0.189`.
- **sklearn check:** `DecisionTreeClassifier(criterion="entropy", max_depth=1)` chose the shots feature at the root, with entropies `[1.0, 0.65, 0.65]`, matching the hand calculation.
- **Honest note on the toy tree:** the second-level Home split lowers entropy, but here it does not change any prediction, because each Shots branch already predicts the same class. Only 12 rows, so this is for learning, not a real model.

## Common Mistakes
- Forgetting to weight the children by size.
- Using the natural log (`ln`) or log base 10 instead of `log₂`.
- Thinking entropy of a pure node is undefined. It is 0.
- Forgetting that the maximum entropy for two classes is 1, not 100%.
- Confusing entropy (a property of one node) with information gain (the drop from parent to children).
- Choosing a split because it looks sensible instead of by the highest IG.
- Assuming a tree is best when every leaf is pure. That can be overfitting.

## Interview Questions
- Explain the structure of a decision tree: root, decision node, leaf.
- What is entropy? Write the formula.
- What is the entropy of a pure node? Of a 50/50 two-class node?
- What is information gain and how is it calculated?
- Why do we weight the child entropies?
- Calculate the information gain for a small split (a counts table is given).
- How does a tree decide which feature goes at the root?
- When does a tree stop splitting? What happens if it never stops?

## Key Takeaways
- Entropy = how mixed a node is. Information gain = how much a question reduces that mix.
- The tree greedily picks the split with the highest information gain at every node.
- Always compute the weighted average of the children's entropy.
- Calculating IG by hand is a very common interview task.
- Trees split until pure or stopped, so they need limits to avoid overfitting.

## Summary
- Trees are built from root, decision nodes and leaves, each splitting on one feature.
- Entropy `−Σ p·log₂(p)` is 0 for a pure node and 1 for a 50/50 mix.
- Information gain = parent entropy − weighted child entropy.
- On the toy data, Shots gave IG 0.350 and Home only 0.082, so Shots became the root.
- **Next: Day 59.** Decision Tree in sklearn plus visualization.
