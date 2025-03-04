import logging
from jaeger_client import Config
from opentracing.ext import tags
from opentracing.propagation import Format
import requests

def init_tracer(service):
    logging.getLogger('').handlers = []
    logging.basicConfig(format='%(message)s', level=logging.DEBUG)
    config = Config(
        config={
            'sampler': {
                'type': 'const',
                'param': 1,
            },
            'logging': True,
        },
        service_name=service,
    )
    # this call also sets opentracing.tracer
    return config.initialize_tracer()

tracer = init_tracer('first-service')

def test():
    # Add your test function here
    with tracer.start_span('TestSpan') as span:
        req = requests.get('https://udacity.com')
        span.set_tag('http.method;', req)
        def format():
            with tracer.start_span('my-test-span') as span:
                try:
                    print("success!")
                except:
                    print("try again")

if __name__ == "__main__":
    test()
