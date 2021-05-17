FROM quay.io/odh-jupyterhub/jupyterhub-img:v0.2.5

ARG user=jeff-phillips-18
ARG branch=test2

ADD run.sh /tmp/run.sh

RUN pip install -e git+https://github.com/${user}/jupyterhub-singleuser-profiles.git@${branch}#egg=jupyterhub_singleuser_profiles

RUN bash /tmp/run.sh