## 2020.11.12

### .jon을 지우면, post,get 은 error가 발생하지만, **patch, update는 Error가 안남.**

- Map 안에 Map이 있을 경우.

- 무한루프 조심!!

- FutureBuilder 사용으로 setState 줄이기!

## 2020.11.11
http 로 파베연동 상품 추가,수정,삭제까지 해 놓았다.

나머지는 알아서 해 보기~~



## -------------------
.

.

.

.

.

.

## 2020.11.06
7일 새벽 5시 50분. 깃에 저장 해 놓겠다.

Edit_product_screen 20번째줄을 활성하 하구 그 아래 초기화부분을 지우면,

NoSuchMethodError 가 발생.

지우지 않으면 에러가 발생하지 않지만, 출력 문구에 의해서
값이 들어가지 않았지만 실행되는 거 같은데, 값 저장은 또 잘 되어있다.........
- '초기화' 가 반드시 필요한 문장인건가?

## 2020.11.05
TextFormField에서 initialValue 와 controller를 같이 사용 불가. (Error에 적어놈)/-

추가, 수정, 삭제 기능 추가.


## 2020.11.03
- Scaffold.of(context).hideCurrentSnackBar();

SnackBar가 연속으로 발생하게되면, 기존에 나타나는 스낵바의 Duration이 완전히 끝나야 다음 스낵바가 표시되었는데,
hideCurrentSnackBar으로 현재 스낵바를 지우면 바로바로 나타날 수 있다.

              (( 그럼 중복해서 나타나게는 안될까? ))

- Dismissed 하기 전에 확인할 수 있는 confirmDismiss!!!!!!!!!!!!!!

Dismissible 에서 confirmDismiss (direction) 요 다이렉션이 스와이프 방향이구만..!

왼쪽,오른쪽,위,아래 어느쪽으로 스와이프 하는지에 따라 어떤 것을 할지 정해 줄 수 있어!

플러터 첫 걸음에서 했던 Dialog가 이상했던 걸까..?

Udemy강의에서는 showDialog를 await하지 않고,
return 이 가능해서 바로~ 해벌임.

            (( 근데, await를 하지 않아도 기다려지네..? ))


## 2020.11.02
212강. 섹션8 수강완료.

장바구니 추가하고, order 하여 구매 페이지에 구매목록 확인 가능.

## 2020.11.01
get을 쓰면 ()를 안붙여도 되는구나..

## 2020.10.29
- 좋아요 표시한 것 만 Grid뽑기.
강의와 내가한 것이 조금 달랐다.
강의에 나온 코드가 간결.

#### 여기서 문제가 하나 있었는데, provider에서 가져오는 건 import안해도 되는데
grid.dart에서 따로 선언하려면 product를 import해야하는데??
