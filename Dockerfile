ARG MATLAB_RELEASE=r2021b
ARG MATLAB_RELEASE_DIR=R2021b
ARG ADDON_LIST="Deep_Learning_Toolbox Econometrics_Toolbox Optimization_Toolbox Statistics_and_Machine_Learning_Toolbox"

FROM mathworks/matlab:${MATLAB_RELEASE}

ARG MATLAB_RELEASE
ARG MATLAB_RELEASE_DIR
ARG ADDON_LIST

USER root

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install --no-install-recommends --yes wget unzip ca-certificates firefox && \
    apt-get clean && apt-get autoremove

RUN wget -q https://www.mathworks.com/mpm/glnxa64/mpm && \ 
    chmod +x mpm && \
    ./mpm install \
        --release=${MATLAB_RELEASE} \
        --destination=/opt/matlab/${MATLAB_RELEASE_DIR} \
        --products ${ADDON_LIST}  && \
    rm -f mpm /tmp/mathworks_root.log 

COPY ./disable-black-screen.sh /home/matlab/.vnc/

RUN chown matlab:matlab /opt/matlab
RUN chmod +x /home/matlab/.vnc/disable-black-screen.sh
RUN echo "\nsh ~/.vnc/disable-black-screen.sh" >> /home/matlab/.vnc/xstartup

USER matlab
