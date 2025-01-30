#!/bin/bash
set -e

# 터미널 출력 색상 정의
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

# 리눅스 아키텍처 확인
ARCH=$(uname -m)
if [[ "$ARCH" == "x86_64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
elif [[ "$ARCH" == "aarch64" ]]; then
    CLIENT_URL="https://cdn.app.multiple.cc/client/linux/arm64/multipleforlinux.tar"
else
    echo -e "${RED}지원하지 않는 아키텍처입니다: $ARCH${NC}"
    exit 1
fi

# 작업 디렉토리 생성 및 이동
INSTALL_DIR="/root/multiple"
echo -e "${GREEN}작업 디렉토리 생성 중...${NC}"
mkdir -p $INSTALL_DIR
cd $INSTALL_DIR

# 클라이언트 다운로드
echo -e "${GREEN}$CLIENT_URL 에서 클라이언트 다운로드 중...${NC}"
wget $CLIENT_URL -O multipleforlinux.tar

# 설치 패키지 압축 해제
echo -e "${GREEN}설치 패키지 압축 해제 중...${NC}"
tar -xvf multipleforlinux.tar

# 압축 해제된 디렉토리로 이동
cd multipleforlinux

# 필요한 실행 권한 설정
echo -e "${GREEN}필요한 실행 권한 설정 중...${NC}"
chmod +x multiple-cli
chmod +x multiple-node

# PATH 환경변수 설정
echo -e "${GREEN}PATH 환경변수 설정 중...${NC}"
echo "PATH=\$PATH:$INSTALL_DIR" >> ~/.bashrc
source ~/.bashrc

# 디렉토리 권한 설정
echo -e "${GREEN}디렉토리 권한 설정 중...${NC}"
chmod -R 777 .

# 식별자와 PIN 입력 받기
echo -e "${YELLOW}1.해당사이트로 이동하여 회원가입을 해주세요.${NC}"
echo -e "${YELLOW}https://www.app.multiple.cc/#/signup?inviteCode=8cYFPN4Y${NC}"
echo -e "${YELLOW}2.가입을 완료하신 후 대시보드사이트에 접속하세요.${NC}"
echo -e "${YELLOW}https://www.app.multiple.cc/#/dataPanel/${NC}"
echo -e "${YELLOW}3.Setup카테고리로 이동 후 identification code를 복사하세요.${NC}"
read -p "위 과정을 완료하신 후 엔터를 눌러주세요: "

read -p "식별자를 입력하세요: " IDENTIFIER
read -p "PIN을 설정하세요(6자리숫자): " PIN

# 프로그램 실행
echo -e "${GREEN}프로그램 실행 중...${NC}"
nohup ./multiple-node > output.log 2>&1 &

# 고유 계정 식별자 바인딩
echo -e "${GREEN}식별자와 PIN으로 계정 바인딩 중...${NC}"
./multiple-cli bind --bandwidth-download 100 --identifier "$IDENTIFIER" --pin "$PIN" --storage 200 --bandwidth-upload 100

# 완료 메시지
echo -e "${GREEN}Multiple 노드 설치 과정이 완료되었습니다.${NC}"
echo -e "${YELLOW}대시보드 사이트는 다음과 같습니다: https://www.app.multiple.cc/#/dataPanel/${NC}"
echo -e "${GREEN}스크립트작성자: https://t.me/kjkresearch${NC}"
