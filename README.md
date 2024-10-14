# 책빵 - 식빵냥이와 함께하는 독서 기록 <img herf="https://apps.apple.com/kr/app/%EC%B1%85%EB%B9%B5-%EC%8B%9D%EB%B9%B5%EB%83%A5%EC%9D%B4%EC%99%80-%ED%95%A8%EA%BB%98%ED%95%98%EB%8A%94-%EB%8F%85%EC%84%9C-%EA%B8%B0%EB%A1%9D/id6730113913" src="https://github.com/user-attachments/assets/1781358b-e9b9-4bc5-b8f4-5c26c281573d" alt="Image 1" width="120px"/>

## 1. 프로젝트 소개

> 귀여운 고양이와 함께하는 독서 기록 앱, 책을 쌓을수록 고양이와 북타워가 함께 성장합니다.

<div>
  <img src="https://github.com/user-attachments/assets/04f091c7-af36-45f9-aeac-01b2f1218c0d" alt="Image 1" width="19%"/>
  <img src="https://github.com/user-attachments/assets/04eb3d10-3014-4454-b700-fd95c446c707" alt="Image 1" width="19%"/>
  <img src="https://github.com/user-attachments/assets/7dbede75-4b2b-4795-8083-d6622183a9d4" alt="Image 1" width="19%"/>
  <img src="https://github.com/user-attachments/assets/9a5c5473-36ea-492b-ba9f-703da14677be" alt="Image 1" width="19%"/>
  <img src="https://github.com/user-attachments/assets/b233cd57-d471-427b-bc28-379f0490c8e0" alt="Image 1" width="19%"/>
</div>

### 1-1. 개발 환경

개발기간: 2024.9.14 - 2024.10.2 ( 약 3주 )<br>
개발인원: 1명<br>
환경설정 : 최소버전 iPhone iOS16 이상, 라이트모드, 세로형 Portrait 전용

### 1-2. 기술스택 및 라이브러리

UI: SwiftUI, Cosmos, AVFoundation<br>
Rective: Combine<br>
Network : Alamofire<br>
DataBase : Realm<br>
ETC : PencilKit, PhotosUI

### 1-3. 핵심적인 기능

- **북타워 쌓기**: 책을 등록시, 페이지 수의 따른 다른 두께의 책이 쌓이고 고양이가 위로 이동함
- **편리한 도서 관리**: ‘읽은 책’, ‘읽고 있는 책’, ‘읽고 싶은 책’으로 도서 분류, 평점과 읽은 기간을 기록
- **독서 기록 관리**: 책에 대한 소감과 좋아하는 글귀를 사진과 함께 기록하며, 사진에 하이라이트를 추가 가능
- **도서 현황 확인**: 읽은 책 수, 메모 수 등 나의 독서 현황을 쉽게 확인 가능


## 2. 아키텍쳐

![architecture](https://github.com/user-attachments/assets/31a0a0d8-eec8-4e71-8deb-01dbad6bb586)

- **MVVM Input/Output/Action 패턴 사용하여 로직의 분리**:<br>
MVVM 패턴을 사용하고 UI와 로직을 분리하고, viewModel은 Input / Output / Action 패턴을 사용하여, 명확한 트리거와 반응체계를 만들려고 하였습니다.
- **Realm의 DTO 사용하여 안정성과 데이터의 일관성을 높임:**<br>
DTO를 사용함으로써 Realm의 라이프 사이클에 의존하지 않고, 안전하게 데이터를 사용할 수 있도록 하였습니다. 또한 비즈니즈 로직과 Realm 모델을 분리하여 코드의 유연성과 유지보수성을 향샹 시키려 하였습니다.
- **ViewModel의 의존성 주입 적용으로 테스트 가능성을 높임:**<br>
ViewModel에 의존성 주입(DI)을 적용하여 의존성을 보다 효율적으로 관리하고, 테스트 가능성을 높였습니다.

## 3. 트러블 슈팅

### 💥3-1. 동일 데이터를 가진 두 개의 뷰에서 발생하는 데이터 삭제 이슈

![troubleshooting01](https://github.com/user-attachments/assets/12345b9d-6d1b-4cb3-8aef-d0edde404e0f)

동일한 데이터를 참조하는 두 개의 뷰가 각각 다른 탭에서 동시에 열리는 상황이 발생했습니다. 이 경우, 한 뷰에서 데이터를 삭제하면 다른 뷰가 해당 데이터를 계속 참조하려고 시도하면서 런타임 이슈가 발생했습니다.

**해결방법**

1. **데이터 관찰자 패턴(Observer Pattern) 적용하여 변경 사항을 전달:**<br>
각 탭의 뷰는 같은 데이터를 참조하고 있지만, 이 데이터가 삭제 되었을 때 이를 즉시 감지하지 못하고, 삭제된 데이터를 계속 사용하려 하기 때문에 런타임 이슈가 생겼습니다. Combine를 이용하여 데이터의 변경 사항을 실시간으로 반영할 수도록 데이터 관찰자 모델(NotificationPublisher)를 적용하였습니다. 하나의 뷰에서 데이터를 삭제하면 다른 뷰에서도 해당 데이터를 즉시 감지하여 화면이 사라지도록 처리하였습니다.
    
    ```swift
    import Combine
    
    class NotificationPublisher {
        static let shared = NotificationPublisher()
        private init() {}
        
        let publisher = PassthroughSubject<String, Never>()
        
        func send(_ id: String) {
            publisher.send(id)
        }
    }
    ```
    
    ```swift
    Button("삭제") {
        NotificationPublisher.shared.send("\(item.id)")
    }
    ...
    .onAppear{
        NotificationPublisher.shared.publisher
        .sink { id in
          ...
        }
        .store(in: &viewModel.cancellables)
    }
    ```
    
2. **Realm 모델을 DTO(Data Transfer Object)로 변환하여 데이터 분리:**<br>
Realm 객체와 직접적으로 상호작용하지 않고, 데이터를 DTO로 변환한 후에 비즈니스 로직이나 UI에 전달하여 사용하는 것이 더 궁극적으로 데이터 관리하는 게 좋은 방법으로 생각되었습니다.  이 방법을 통해 Realm 객체의 라이프사이클에 의존하지 않고, 안전하게 데이터를 관리할 수 있게 되었습니다.
    
    ```swift
    final class MyBook: Object, ObjectKeyIdentifiable {
      ...
      func toMyBookDTO() -> MyBookDTO {
        .init(id: id, itemId: itemId, ... )
      }
    }
    ```
    

### 💥3-2. 네트워크가 실패했을때 스트림이 종료되어 다시 이벤트를 받지 못하는 이슈

![troubleshooting02](https://github.com/user-attachments/assets/0aba856a-6b52-47a6-b3b8-093bb254327c)

네트워크가 일시적으로 끊기면 에러를 반환하여 이벤트 스트림이 중단되고, 네트워크가 다시 복구되어도 새로운 데이터를 받지 못하는 문제가 발생했습니다. 

**해결 방법**

1. **네트워크 통신시  `Result` 타입으로 응답을 맵핑하여 반환하도록 변경:**<br>
네트워크 통신 시 `Result` 타입으로 응답을 감싸서 반환하는 방식으로 문제를 해결했습니다. 이렇게 하여 **성공**과 **실패** 케이스 모두를 `Result` 타입으로 처리할 수 있고, promise의 반환값은 무조건 성공을 반환하기 때문에 스트림이 종료되지 않도록 만들 수 있었습니다. 이로 인해, 스트림은 네트워크 요청의 성공 여부와 상관없이 계속 유지되며, 실패한 경우에도 종료되지 않고 새로운 이벤트를 받을 수 있게 되었습니다.

    ```swift
    func fetchBookList(_ search: String) -> AnyPublisher<Result<Book, BookNetworkError>, Never> {
      Future { promise in
        Task { [weak self] in
          do {
              guard let self else { return }
              let value = try await self.callRequest(api: .list(query: search), model: Book.self)
              promise(.success(.success(value)))
                        
          } catch {
              guard let self else { return }
              promise(.success(.failure(self.networkErrorHandling(error: error))))   
          }
        }
      }
      .eraseToAnyPublisher()
    ```
    
    ```swift
    input.searchOnSubmit
      .flatMap { value in
          return NetworkManager.shared.fetchBookList(value)
      }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] result in
          guard let self else { return }
          switch result {
          case .success(let value):
          self.searchResult = value
            ...
          case .failure(let error):
          switch error {
          case .notConnectedToInternet:
          self.output.searchFailure = "오프라인 상태입니다. 인터넷 연결을 확인하세요."
            ...
          }
      })
      .store(in: &cancellables)
    ```
## 4. 회고

1. 검색 결과를 보여줄 때 페이지네이션을 구현하고 싶었으나, API에서 다른 요청에도 같은 결과값을 전달해주어 페이지네이션을 구현하지 못하였습니다. 차선택으로 한번에 많은 결과물을 보여주는 방법을 택하여 아쉬움이 남습니다. RestAPI의 특성상 결과 값은 개발자가 변화 시킬 수 없는 부분이 이기 때문에, 어떻게 하면 이 부분을 개발적으로 커버할 수 있을까 고민보아야 할 것 같습니다. 
2. 네트워크 에러처리  시 API가 에러처리(응답코드) 가이드를 주지 않아 NSError를 통해 통신 에러처리를 하긴 했지만 그 외에 에러처리는 어떻게 하면 좋을 지 고민해보고 리팩토링이 필요가 있을 것 같습니다.
