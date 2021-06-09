FROM tensorflow/tensorflow:latest-gpu



# ---- add container user
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME --shell /usr/bin/fish \
    # add sudo support
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME


# ---- install python 3.8
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --yes --no-install-recommends \
       software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
       python3.8 python3-pip \
    && /usr/bin/python3.8 -m pip install --upgrade pip


# ---- install fish
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --yes --no-install-recommends \
       software-properties-common \
    && apt-add-repository ppa:fish-shell/release-3 \
    && DEBIAN_FRONTEND=noninteractive apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install --yes --no-install-recommends \
       fish curl
RUN mkdir -p /home/$USERNAME/.config/fish/functions/

# custom terminal prompt
RUN TARGET=/home/$USERNAME/.config/fish/functions/fish_prompt.fish \
    && echo "function fish_prompt -d 'Write out the prompt'" >> $TARGET \
    && echo "    printf '\n%s%s%s -> ' (set_color green)(prompt_pwd)(set_color normal)" >> $TARGET \    
    && echo "end" >> $TARGET

# easy access to cheat.sh/
RUN TARGET=/home/$USERNAME/.config/fish/functions/cht.fish \
    && echo "function cht -d 'use cheat.sh'"    >> $TARGET \
    && echo "    curl cheat.sh/\$argv"          >> $TARGET \
    && echo "end"                               >> $TARGET

# make sure that user can write all fish configs
RUN chown -R $USERNAME /home/$USERNAME/.config


# ---- install tools
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --yes --no-install-recommends \
       ssh-client git \
    && rm -rf /var/lib/apt/lists/*
