FROM python:3.10

ENV PROJ_PATH=/usr/src/app
ENV KUBESPRAY_PATH=/usr/src/kubespray
ENV KUBESPRAY_VERSION="v2.19.0"

WORKDIR $PROJ_PATH

# Install kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
RUN apt update \
    && apt install -y apt-transport-https ca-certificates \
    && curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list \
    && apt update \
    && apt install -y kubectl

COPY requirements.txt .

RUN git clone --depth 1 --branch "$KUBESPRAY_VERSION" https://github.com/kubernetes-sigs/kubespray.git "$KUBESPRAY_PATH" \
  && cd "$KUBESPRAY_PATH" \
  && cat "$PROJ_PATH"/requirements.txt >> requirements.txt \
  && pip install -r requirements.txt

COPY . .

ENTRYPOINT ["/bin/bash", "./bin/container/entrypoint.sh"]
