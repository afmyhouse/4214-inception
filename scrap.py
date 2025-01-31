import requests
from bs4 import BeautifulSoup

# Step 1: Send a GET request to the website
url = "https://antonio-ferreira.com"
response = requests.get(url)

# Check if the request was successful
if response.status_code == 200:
    # Step 2: Parse the HTML content using BeautifulSoup
    soup = BeautifulSoup(response.text, 'lxml')

    # Step 3: Extract data (example: extract the title of the page)
    title = soup.title.string
    print(f"Title of the page: {title}")

    # Step 4: Extract other elements (example: all links on the page)
    links = soup.find_all('a')
    for link in links:
        print(link.get('href'))

else:
    print(f"Failed to retrieve the page. Status code: {response.status_code}")