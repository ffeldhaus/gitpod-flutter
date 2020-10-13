FROM gitpod/workspace-full:latest

ENV ANDROID_HOME=/home/gitpod/android-sdk \
    FLUTTER_HOME=/home/gitpod/flutter

USER root

RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && \
    apt-get -y install build-essential dart libkrb5-dev gcc make gradle android-tools-adb android-tools-fastboot openjdk-8-jdk && \
    apt-get clean && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*;

USER gitpod

RUN cd /home/gitpod && \
    git clone https://github.com/flutter/flutter.git -b stable --depth 1

RUN cd /home/gitpod && \
    wget -qO android_studio.tar.gz \
    https://dl.google.com/dl/android/studio/ide-zips/4.1.0.19/android-studio-ide-201.6858069-linux.tar.gz && \
    tar -xzf android_studio.tar.gz && \
    rm -f android_studio.tar.gz

https://dl.google.com/android/repository/commandlinetools-win-6609375_latest.zip

ARG ANDROID_SDK_VERSION=6609375
RUN mkdir -p /home/gitpod/android-sdk && \
    cd /home/gitpod/android-sdk && \
    wget -qO commandlinetools.zip \
    https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip commandlinetools.zip && \
    rm -f commandlinetools.zip    