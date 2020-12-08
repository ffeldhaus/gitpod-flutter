FROM gitpod/workspace-full:latest

ENV ANDROID_HOME=/home/gitpod/android-sdk \
    FLUTTER_HOME=/home/gitpod/flutter
ENV ANDROID_CMDLINE_TOOLS=$ANDROID_HOME/cmdline-tools

USER root

# install dependencies
RUN curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && \
    apt-get -y install build-essential dart libkrb5-dev gcc make gradle android-tools-adb android-tools-fastboot libpulse0 libgl1-mesa-glx && \
    apt-get clean && \
    apt-get -y autoremove && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*;

# ensure that JDK is set to 8 until Flutter supports more recent JDK versions
RUN bash -c ". /home/gitpod/.sdkman/bin/sdkman-init.sh \
             && sdk install java \$(sdk list java | grep ' 8.' | grep j9-adpt | head -1 | awk -F '|' '{ print \$6 }')"

USER gitpod

# install flutter
RUN cd /home/gitpod && \
    git clone https://github.com/flutter/flutter.git -b stable --depth 1 --no-single-branch

# install android studio
RUN cd /home/gitpod && \
    wget -qO android_studio.tar.gz \
    https://dl.google.com/dl/android/studio/ide-zips/4.1.0.19/android-studio-ide-201.6858069-linux.tar.gz && \
    tar -xzf android_studio.tar.gz && \
    rm -f android_studio.tar.gz

# install android cmdline tools
ARG ANDROID_SDK_VERSION=6609375
RUN mkdir -p $ANDROID_CMDLINE_TOOLS && \
    cd $ANDROID_CMDLINE_TOOLS && \
    wget -qO commandlinetools.zip \
    https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip && \
    unzip commandlinetools.zip && \
    rm -f commandlinetools.zip    

# pre-download flutter development binaries
RUN $FLUTTER_HOME/bin/flutter precache

# add flutter web support
RUN $FLUTTER_HOME/bin/flutter channel beta && \
    $FLUTTER_HOME/bin/flutter upgrade && \
    $FLUTTER_HOME/bin/flutter config --enable-web

# install AAndroid SDK platform tools for specific android version(s) and accept licenses
RUN yes | $ANDROID_CMDLINE_TOOLS/tools/bin/sdkmanager "platform-tools" "platforms;android-30" "build-tools;30.0.0" && \
    yes | $ANDROID_CMDLINE_TOOLS/tools/bin/sdkmanager --licenses
