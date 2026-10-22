# Predator–prey simulation activity · ENSCI 3120

Designed for a 75-minute class with approximately 400 students. Reserve 20 minutes for this activity after briefly connecting zebra mussel community effects to predator–prey feedback. It is one segment of the period, leaving 55 minutes for the opening, other applications, and synthesis.

## Learning targets

Students will explain a predator–prey time lag, distinguish initial conditions from growth constraints, and use carrying capacity and a predator growth threshold to predict persistence. They will distinguish model results from evidence about a real ecological community.

## Opening bridge (outside the 20-minute app segment)

Retrieve before revealing: “In the zebra mussel case, how could a predator change the community without reducing total mussel abundance?” Allow 30 seconds of individual thinking and 45 seconds of partner explanation. Reveal the body-size/feeding link as a reasonable explanation. Then ask: “What might we learn from a simpler model that ignores body size—and what might it miss?”

## Student-facing prompt

**Why don’t predators simply eat all their prey?**

Work with a neighbor. Before each run, write a prediction and explain why. Run the model, identify evidence in the graph, and revise your explanation. Change one variable at a time. Both partners should be ready to explain the result; submit answers individually in Top Hat.

1. Run the default classic model. Which population peaks first? Find an interval when prey are declining while predators are still increasing. Explain how both can happen at once.
2. Predict the effect of increasing initial prey density from 40 to 80 while holding everything else fixed. Test it. Does the starting density change the conditions that determine whether predators increase?
3. Reset, choose limited resources, and run K=100. Compare with the classic result. Then predict and test K=25. Explain why carrying capacity can determine whether predators persist.

## Timing and facilitation (20 minutes)

| Minutes | Activity |
|---|---|
| 0–2 | Individual prediction, partner explanation, open app. |
| 2–6 | Default classic run; locate and explain the lag. Top Hat 1. |
| 6–9 | Change initial prey only; compare and explain. |
| 9–14 | Reset; logistic K=100, then K=25. Predict before each run. |
| 14–18 | Top Hat 2, discuss with partner, revote; reveal reasoning. |
| 18–20 | Each student revises one explanation and names one omitted mechanism. |

Use simultaneous individual responses before partner discussion to broaden participation without suppressing students who are already engaged. Display the response distribution and address the most common misconception. Students can self-check against the explanation; no live grading of 400 written answers is needed. Optional challenge for early finishers: find initial conditions that produce a flat line, then explain why.

This sequence applies Small Teaching principles through retrieval, prediction, explanation, and timely feedback followed by revision. These are design choices, not evidence that this particular activity has already improved learning.

## Top Hat 1 · Multiple choice with reasons

**In one interval, prey density is decreasing while predator density is still increasing. Is this possible under the model?**

A. True, because prey can remain abundant enough to support predator growth even while losses to predation exceed prey reproduction.

B. True, because predators no longer depend on prey once predators become abundant.

C. False, because predator and prey growth rates must always have the same sign.

D. False, because predators begin declining as soon as prey density begins declining.

**Correct: A.** The two populations have different zero-growth conditions. Prey decline when predation exceeds prey production; predators can still increase if food supports more births than deaths. The lag reflects this feedback, not an explicit gestation delay in these equations.

## Top Hat 2 · Multiple choice with reasons

**In the limited-resource model, predators increase only when prey density exceeds 50. Carrying capacity is reduced from 100 to 25, with all other parameters unchanged. Can simply doubling the initial number of predators make the predator population persist in the long run?**

A. True, because starting with more predators guarantees more births than deaths indefinitely.

B. True, because adding predators raises the prey carrying capacity.

C. False, because the prey population cannot sustain the density needed for positive predator growth when its carrying capacity is only 25.

D. False, because predators must go extinct immediately whenever prey density is less than 50.

**Correct: C.** Initial predator density changes the transient trajectory, not K or the prey threshold for predator growth. Decline is gradual in the continuous deterministic model; do not equate a small plotted value with immediate biological extinction. Explain that K is the prey carrying capacity without predators, not a target the prey must reach when predators are present.

## Instructor reveal / optional quantitative extension

With default rates, predator per-capita growth is baN−m, so its sign changes at N=m/(ba)=50. Classic prey per-capita growth is r−aP, changing sign at P=25. With logistic prey, the prey zero-growth line becomes P=(r/a)(1−N/K). At K=100 the coexistence intersection is N=50, P=12.5. At K=25 there is no positive coexistence intersection.

Use the phase plot only after students describe the time series. Ask them to predict the direction of change at a point before showing the zero-growth lines.
