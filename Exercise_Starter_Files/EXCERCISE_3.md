### Outline:
This lesson is all about reliability metrics. In order to observe performance, we first need to get clear on how we are defining and measuring it, and that's what we'll cover here.

- Defining performance. The first thing we need to do is define what we mean by site reliability or performance. We will talk about performance in terms of providing a certain level of service, and we'll go over what are called the four golden signals that are used in site reliability modeling.
- Service-Level Objectives (SLOs). We also need a clear objective or goal, and this is where Service-Level Objectives (or SLOs) come in. We will talk about what SLOs are and what factors to consider when setting them.
- Service-level indicators (SLIs) . Once we have a clear definition and objective for the level of performance we want to deliver, we need to consider how we will actually measure this performance. This is done using Service-Level Indicators or SLIs.
- Error Budgets. Since we cannot guarantee 100% performance, we need to plan for errors. For example, if we are OK with 99% reliability on a metric, that means we have an error budget of 1%. We are deciding that if things get any worse than that 1%, this is a signal to us that an improvement is needed.
- Building SLAs. Finally, we will bring this all together and examine Service-Level Agreements or SLAs. While you personally won’t have to worry about SLAs as an SRE, it is important to understand the context of SLAs as it does play a part in the overall SRE model.

### What is SLI depend on ( 4 golden rules)
Typically, service is defined in terms of four core properties, called the Four Golden Signals:

- Latency — The time taken to serve a request (usually measured in ms).
- Traffic — The amount of stress on a system from demand (such as the number of HTTP requests/second).
- Errors — The number of requests that are failing (such as number of HTTP 500 responses).
- Saturation — The overall capacity of a service (such as the percentage of memory or CPU used).

These signals are generally considered the pillars of SRE best practices because most issues will fall into one of these four categories. By defining performance in these terms, it’s easier to plan, identify, and execute when we are building our goals for our service level.


### Excercise SLO (Service level objectives)
#### Questions and solution:
Check iPyhton NB file: [Guide.ipynb](Guide.ipynb)
#### Answers:
Check iPython NB file: [SLOs.ipynb](SLOs.ipynb)

### Excersise SLI (Serivce level indicator)
#### Questions:
Let's get some practice to make sure that we understand SLIs. Like we did with SLOs, let's start with a non-technical, everyday scenario.

Suppose that you are monitoring the performance of services at a fast food restaurant. See if you can describe 3–5 SLIs that you could use to measure performance.

#### Answers given:
- We measure a queue lane with more than 3 people during 10 min. per day. (< 2%/day)
- At the end of day they were 3 complains out of 660 customers about the food quality (<0.5 %)
- We did measure a downtime of our POS systems of 16 min. during one month (Meets SLO Uptime 99.9%)

#### Solutuon given:
Your answers will most likely differ from mine, but here are some reasonable examples that you might have picked:

Number of orders filled/hour.
Number of 5-star ratings/day.
Number of returned orders/week.
Hamburgers sold/month.
Percentage of late orders (fulfillment time >10 minutes)/hour.

Remember, when you think of SLIs, think in terms of ratios—a number of X / Y, where X is a measurement and Y is (typically) an amount of time.
