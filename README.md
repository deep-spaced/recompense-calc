# Recompense Calc

To install dependencies:

```
bundle install
```

## Testing

```
rake test
```

## Rules

First day and last day of a project, or sequence of projects, is a travel day.
Any day in the middle of a project, or sequence of projects, is considered a full day.
If there is a gap between projects, then the days on either side of that gap are travel days.
If two projects push up against each other, or overlap, then those days are full days as well.
Any given day is only ever counted once, even if two projects are on the same day.
A travel day is reimbursed at a rate of 45 dollars per day in a low cost city.
A travel day is reimbursed at a rate of 55 dollars per day in a high cost city.
A full day is reimbursed at a rate of 75 dollars per day in a low cost city.
A full day is reimbursed at a rate of 85 dollars per day in a high cost city.

