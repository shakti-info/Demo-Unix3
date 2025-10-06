# Use an official Python runtime
FROM python:3.9

# Set working directory
WORKDIR /var/www/html

# Install system dependencies for mysqlclient
RUN apt-get update && \
    apt-get install -y gcc default-libmysqlclient-dev pkg-config && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt /var/www/html/

# Install Python dependencies
RUN pip install mysqlclient
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . /var/www/html/

# Expose the Flask app port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
