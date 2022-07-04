FROM --platform=x86_64 ubuntu:22.04 as bits-build
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y build-essential \
                                 git vim autogen \
                                 python2.7 autotools-dev \
                                 autoconf bison flex zip \
                                 libffi-dev xorriso mtools
RUN update-alternatives --install /usr/bin/python python /usr/bin/python2.7 1
WORKDIR /root
RUN rm -Rf bits && git clone https://github.com/ani-sinha/bits.git -b bits-qemu-logging 
WORKDIR /root/bits
RUN git submodule update --init
RUN make -j 10
RUN echo $(expr 2000 + `git rev-list HEAD 2>/dev/null | wc -l`) > bits-version
RUN cd build && tar -czf bits-$(expr 2000 + `git rev-list HEAD 2>/dev/null | wc -l`)-grub.tar.gz grub-inst-x86_64-efi grub-inst
RUN mv build/*.tar.gz .

