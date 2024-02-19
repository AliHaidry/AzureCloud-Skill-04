import logging
import datetime
import requests
import azure.functions as func

app = func.FunctionApp(http_auth_level=func.AuthLevel.FUNCTION)

@app.route(route="hero_function")
def hero_function(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    name = req.params.get('name')
    if not name:
        try:
            req_body = req.get_json()
        except ValueError:
            pass
        else:
            name = req_body.get('name')

    if name:
        return func.HttpResponse(f"Hello, {name}. This HTTP triggered function executed successfully.")
    else:
        return func.HttpResponse(
             "This HTTP triggered function executed successfully. Hello to the Azure Cloud. Hope this works!!!",
             status_code=200
        )
    
@app.route(route="current_time")
def timer_function(req: func.HttpRequest) -> func.HttpResponse:
    current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    return func.HttpResponse(f"Current time is: {current_time}")


@app.route(route="population")
def can_population(req: func.HttpRequest) -> func.HttpResponse:
    population_data = fetch_population_data()
    return func.HttpResponse(f"The current population of Canada is: {population_data}")


def fetch_population_data():
    # Fetch population data from a reliable source
    response = requests.get("https://world-population.p.rapidapi.com/population?country_name=Canada")
    data = response.json()
    population = data['body']['population']
    return population