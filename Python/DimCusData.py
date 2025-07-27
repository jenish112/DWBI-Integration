# Impoert python libraries
import csv
import random
from faker import Faker

# Insitialization
fake = Faker()

# Input the number of rows
num_rows = int(input("Enter the number of rows and csv file: "))

# Input the name of the csv file
csv_file = input("Enter the name of the csv file: ")

# Open CSV file
with open(csv_file, mode = 'w', newline='') as file:
    writer = csv.writer(file)

# Create the header
    header = ['First Name', 'Last Name', 'Gender', 'DOB', 'Email', 'Phone Number', 'Address', 'City', 'State', 'Postal Code', 'Country', 'LoyaltyProgramID']

# Write the header to the csv file
    writer.writerow(header)

# Loop and generate multiple rows
    for _ in range(num_rows):
        row = [
            fake.first_name(),
            fake.last_name(),
            random.choice(['M', 'F', 'Others']),
            fake.date(),
            fake.email(),
            fake.phone_number(),
            fake.address().replace("\n", " "),
            fake.city(),
            fake.state(),
            fake.postcode(),
            fake.country(),
            random.randint(1, 5)
        ]

        writer.writerow(row)

# Generate a singla row

# Write the row to the csv file

# Print success statement
print('The file has been loaded successfully')