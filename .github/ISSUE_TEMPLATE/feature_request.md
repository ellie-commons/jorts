---
name: Feature request
about: Suggest an idea for this project
title: "[FR]"
labels: ''
assignees: ''

---

name: Feature Request
description: Suggest a new idea or request a missing feature
labels: ["Priority: Wishlist", "Needs Design"]
type: "Feature"

body:
  - type: markdown
    attributes:
      value: |
          * Please read these [Tips](https://docs.elementary.io/contributor-guide/feedback/creating-feature-requests)
          * Be sure to search open and closed issues for duplicates

  - type: textarea
    attributes:
      label: Problem
      description: Describe the problem that this new feature or idea is meant to address
    validations:
      required: true

  - type: textarea
    attributes:
      label: Proposal
      description: Describe the new feature or idea that you would like to propose and how it solves the problem
    validations:
      required: true

  - type: textarea
    attributes:
      label: Prior Art (Optional)
      description: List any supporting examples of how others have implemented this feature
    validations:
      required: false

**Additional context**
Add any other context or screenshots about the feature request here.
