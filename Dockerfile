FROM debian:latest
WORKDIR /
ENV settingsFile="mpd.conf"

# build dependency
RUN apt-get update
RUN apt-get install -y wget \
  meson g++ \
  libfmt-dev \
  libpcre2-dev \
  libmad0-dev libmpg123-dev libid3tag0-dev \
  libflac-dev libvorbis-dev libopus-dev libogg-dev \
  libadplug-dev libaudiofile-dev libsndfile1-dev libfaad-dev \
  libfluidsynth-dev libgme-dev libmikmod-dev libmodplug-dev \
  libmpcdec-dev libwavpack-dev libwildmidi-dev \
  libsidplay2-dev libsidutils-dev libresid-builder-dev \
  libavcodec-dev libavformat-dev \
  libmp3lame-dev libtwolame-dev libshine-dev \
  libsamplerate0-dev libsoxr-dev \
  libbz2-dev libcdio-paranoia-dev libiso9660-dev libmms-dev \
  libzzip-dev \
  libcurl4-gnutls-dev libyajl-dev libexpat-dev \
  libasound2-dev libao-dev libjack-jackd2-dev libopenal-dev \
  libpulse-dev libshout3-dev \
  libsndio-dev \
  libmpdclient-dev \
  libnfs-dev \
  libupnp-dev \
  libavahi-client-dev \
  libsqlite3-dev \
  libsystemd-dev \
  libgtest-dev \
  libboost-dev \
  libicu-dev \
  libchromaprint-dev \
  libgcrypt20-dev

# get source file of mpd and extract this file
RUN wget https://www.musicpd.org/download/mpd/0.23/mpd-0.23.12.tar.xz
RUN tar xf mpd-0.23.12.tar.xz

WORKDIR /mpd-0.23.12

# build mpd
RUN meson . output/release --buildtype=debugoptimized -Db_ndebug=true
RUN meson configure output/release
RUN ninja -C output/release
RUN ninja -C output/release install

# copy settings to /etc from the directory which you set.
COPY ${settingsFile} /etc/mpd.conf

# RUN mpd command with no daemon option to run in foreground
CMD ["mpd", "--no-daemon", "/etc/mpd.conf"]
