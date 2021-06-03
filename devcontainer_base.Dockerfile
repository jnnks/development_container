FROM ubuntu:20.04
RUN apt-get update

# ---- install python
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --yes --no-install-recommends \
       software-properties-common

RUN add-apt-repository ppa:deadsnakes/ppa       

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --yes --no-install-recommends \
       python3.8 python3-pip\
    && rm -rf /var/lib/apt/lists/*


# ---- install fish
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install --yes --no-install-recommends \
       fish curl \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p ~/.config/fish/functions/

# custom terminal prompt
ENV TARGET=~/.config/fish/functions/fish_prompt.fish
RUN    echo "function fish_prompt -d 'Write out the prompt'" >> $TARGET \
    && echo "    printf '%s %s%s%s > ' $USER (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)" >> $TARGET \
    && echo "end" >> $TARGET

# easy access to cheat.sh/
ENV TARGET=~/.config/fish/functions/cheat.fish
RUN    echo "function cheat -d 'use cheat.sh'"  >> $TARGET \
    && echo "    curl 'cheat.sh/$1'"            >> $TARGET \
    && echo "end"                               >> $TARGET
