FROM pytorch/pytorch:latest

# Set the working directory in the container
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    ffmpeg \
    libsndfile1 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Clone the repository
RUN git clone https://github.com/KPEKEP/universal-llm-chatbot.git .

# Remove perinstalled whisper
RUN pip uninstall -y whisper

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Create /app/data/ollama directory and set OLLAMA_MODELS env variable
RUN mkdir -p /app/data/ollama
ENV OLLAMA_MODELS=/app/data/ollama

# Install ollama
RUN curl -fsSL https://ollama.com/install.sh | sh
COPY ./ollama_setup.sh /app/
RUN chmod +x /app/ollama_setup.sh
RUN /app/ollama_setup.sh

# Entrypoint to run the bot
CMD ["python", "main.py"]