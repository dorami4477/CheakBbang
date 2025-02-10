# 책빵 - 식빵냥이와 함께하는 독서 기록 🐈 <img herf="https://apps.apple.com/kr/app/%EC%B1%85%EB%B9%B5-%EC%8B%9D%EB%B9%B5%EB%83%A5%EC%9D%B4%EC%99%80-%ED%95%A8%EA%BB%98%ED%95%98%EB%8A%94-%EB%8F%85%EC%84%9C-%EA%B8%B0%EB%A1%9D/id6730113913" src="https://github.com/user-attachments/assets/1781358b-e9b9-4bc5-b8f4-5c26c281573d" alt="Image 1" width="120px"/>



> 귀여운 고양이와 함께하는 독서 기록 앱, 책을 쌓을수록 고양이와 북타워가 함께 성장합니다.

<div>
  <img src="https://github.com/user-attachments/assets/04f091c7-af36-45f9-aeac-01b2f1218c0d" alt="Image 1" width="19%"/>
  <img src="https://github.com/user-attachments/assets/04eb3d10-3014-4454-b700-fd95c446c707" alt="Image 1" width="19%"/>
  <img src="https://github.com/user-attachments/assets/7dbede75-4b2b-4795-8083-d6622183a9d4" alt="Image 1" width="19%"/>
  <img src="https://github.com/user-attachments/assets/9a5c5473-36ea-492b-ba9f-703da14677be" alt="Image 1" width="19%"/>
  <img src="https://github.com/user-attachments/assets/b233cd57-d471-427b-bc28-379f0490c8e0" alt="Image 1" width="19%"/>
</div>

## 1. 프로젝트 개요

### 1-1. 개발 환경

개발기간: 2024.9.14 - 2024.10.2 ( 약 3주 )<br>
개발인원: 1명<br>
환경설정: 최소버전 iOS16 이상, 라이트모드, 세로형 Portrait 전용

### 1-2. 기술스택 및 라이브러리

UI: SwiftUI, Cosmos, AVFoundation<br>
Rective: Combine<br>
Network: Alamofire<br>
DataBase: Realm<br>
ETC: PencilKit, PhotosUI

### 1-3. 핵심적인 기능

- **북타워 쌓기**: 책을 등록시, 페이지 수의 따라 다른 두께의 책이 쌓이고 고양이가 위로 이동함
- **편리한 도서 관리**: ‘읽은 책’, ‘읽고 있는 책’, ‘읽고 싶은 책’으로 도서 분류, 평점과 읽은 기간을 기록
- **독서 기록 관리**: 책에 대한 소감과 좋아하는 글귀를 사진과 함께 기록하며, 사진에 하이라이트를 추가 가능
- **도서 현황 확인**: 읽은 책 수, 메모 수 등 나의 독서 현황을 쉽게 확인 가능


## 2. 아키텍쳐 및 개발 포인트

![FigJam Untitled](https://github.com/user-attachments/assets/595b3e77-d76a-42eb-8346-d7bb473eb649)

### 아키텍처

- **MVVM 패턴, Combine Reactive Framework, Realm Database**
    - MVVM의 Input/Output/Action 패턴을 사용하여 데이터 흐름을 명확히 정의
    - Realm의 DTO를 활용하여 데이터의 안정성과 유지보수성을 향상
    - 구현체의 의존성을 줄이고 테스트 용이성을 높이기 위해 데이터베이스 Repository에 DIP(Dependency Inversion Principle)를 적용
    - 화면 전환 시 성능 최적화를 위해 초기화 지연 뷰(NavigationLazyView)를 활용
    - 파일 매니저를 통해 이미지 관리의 효율성을 향상
    - 메모리 효율성을 높이기 위해 온보딩 화면에서 분기 처리 및 사용된 메모리를 해제
    - 사용자 사용성 향상을 위해 앱버전 관리 매니저를 만들고 앱 버전 업데이트를 안내함

### 네트워크

- **Alamofire**
    - NSURLErrorDomain을 사용하여 네트워크 에러 코드를 세분화하여 정확한 오류 메시지를 전달
    - 네트워크 요청 함수에 제네릭 타입을 적용하여 재사용성을 높이고, `async/await`를 통해 가독성을 향상
    - API의 Router에 URLRequestConvertible의 TargetType을 적용하여 네트워크 요청 구성을 일관되게 유지하고 유지보수를 용이성을 높임
    - 로딩 프로세스 바, 응답 데이터가 비어 있을 때 토스트 메시지 사용, 데이터 로드 실패 시 임시 데이터 처리 등을 통해 사용자 경험을 향상

### UI

- 아래에서 위로 쌓이는 책 리스트를 구현하기 위해, 위에서 아래로 표시되는 리스트를 역전시킴. 각 책 이미지의 높이에 맞춰 여백을 계산하여, 데이터가 자연스럽게 아래에서 위로 올라오는 UI 구현
- **AVFoundation, PhotosUI, PencilKit**
    - PencilKit을 활용하여 하이라이트 기능을 구현하기 위해 이미지와 캔버스를 병합하여 최종 이미지를 저장
    - AVFoundation를 이용하여 사용자의 카메라로 촬영하고, 촬영된 이미지에 펜 터치를 오버랩 함

## 3. 트러블 슈팅

### 💥3-1. 동일 데이터를 가진 두 개의 뷰에서 발생하는 데이터 삭제 이슈

![Untitled from FigJam (21)](https://github.com/user-attachments/assets/fe81b305-d43e-4fa8-b770-a08e0ad49217)


동일한 데이터를 참조하는 두 개의 뷰가 각각 다른 탭에서 동시에 열려 있을 때, 한 뷰에서 데이터를 삭제하는 경우 해당 데이터를 참조하고 있던 다른 뷰에서 런타임 이슈가 발생합니다.

**해결방법**

1. **데이터 관찰자 패턴(Observer Pattern)을 적용하여 삭제이벤트 전달:**

    각 탭의 뷰는 같은 데이터를 참조하고 있지만, 이 데이터가 삭제 되었음에도 동일한 데이터를 계속 사용하려 하기 때문에 런타임 이슈가 생겼습니다. Combine을 이용하여 데이터의 변경 사항을 실시간으로 반영할 수 있도록 데이터 관찰자 모델(NotificationPublisher)을 적용하였습니다. 하나의 뷰에서 데이터를 삭제하면 다른 뷰에서도 해당 데이터를 즉시 감지하여 화면이 사라지도록 처리하였습니다.
    
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
    
2. **Realm 모델을 DTO(Data Transfer Object)로 변환하여 데이터 분리:**

    Realm의 데이터를 DTO로 변환하여 사용함으로써, 여러 곳에서 동일한 데이터가 같은 주소값을 참조하는 형태가 아닌 값이 복사되는 형태로 변경 할 수 있었습니다. 그로 인해, Realm 데이터에 직접적인 영향이 미치지 않게 되어 데이터의 안정성을 확보하는 동시에 런타임 이슈를 해결 할 수 있었습니다.
    
    ```swift
    final class MyBook: Object, ObjectKeyIdentifiable {
      ...
      func toMyBookModel() -> MyBookModel {
        .init(id: id, itemId: itemId, ... )
      }
    }
    ```
    
---
### 💥3-2. 네트워크가 실패했을때 스트림이 종료되어 다시 이벤트를 받지 못하는 이슈

![Untitled from FigJam (22)](https://github.com/user-attachments/assets/42e03f71-dbd2-4b21-be55-01cea36b017d)

네트워크가 일시적으로 끊기면 에러를 반환하여 이벤트 스트림이 중단되고, 네트워크가 다시 복구되어도 새로운 데이터를 받지 못하는 문제가 발생했습니다. 

**해결 방법**

1. **네트워크 통신 시  `Result` 타입으로 응답을 래핑하여 반환하도록 변경:**
   
    네트워크 통신 시 Result 타입으로 응답을 감싸서 반환하는 방식으로 문제를 해결했습니다. 이렇게 하여 성공과 실패 케이스 모두를 Result 타입으로 처리할 수 있고, promise의 반환값은 성공을 보장하기 때문에 스트림이 종료되지 않도록 만들 수 있었습니다. 이로 인해, 스트림은 네트워크 요청의 성공 여부와 상관없이 계속 유지되며, 실패한 경우에도 종료되지 않고 새로운 이벤트를 받을 수 있게 되었습니다.

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
---    
### 💥3-3. **데이터 관찰자 패턴를 사용했을 때 View와 ViewModel이 메모리 해제 되지 않는 이슈**

동일한 구조체 내에서 이벤트 송수신을 관찰하는 패턴을 적용했으나, viewModel의 deinit이 호출되지 않는 문제가 발생했습니다. 첫 번째 원인은 구독을 저장하는 cancellables를 구조체 내에서 @State로 관리하고 있었기 때문입니다. 두 번째로, cancellables가 뷰의 생명 주기와 제대로 연계되지 않으면 구독이 유지되어 메모리에서 해제되지 않습니다. 또한, 이벤트 수신을 위해서는 cancellables가 해제되지 않고 유지되어야 한다는 문제도 있었습니다.

**해결방법**

1. **이벤트를 수신하는 시점과 pop 동작 시점에만 cancellables 제거:**

    onDisappear시점에 cancellables를 제거할 경우, 다른 뷰로 이동했을 때 구독이 사라져 이벤트를 받을 수 없게 되는 상황이 되기 때문에, 이벤트를 수신하는 시점에만 cancellables를 제거하도록 구현하였습니다. 또한, 이벤트 송신이 이루어지지 않을 때는 onDisappear의 pop이 발생할 때만 cancellables를 제거하여, 안정적인 이벤트 처리를 보장했습니다.
2. **cancellables를 View가 아니라 ViewModel이 관리:**
   
    ViewModel에서 cancellables를 관리함으로써, View에서 cancellables를 사용할 경우 @State 프로퍼티를 사용해야하는 문제를 없앴습니다.

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
        //삭제 이벤트 전달
        NotificationPublisher.shared.send("\(item.id)")
        dismiss()
    }
    ...
    .onAppear{
        NotificationPublisher.shared.publisher
        .sink { id in
          if id == "\(item.id)" {
            //삭제 이벤트 수신
            viewModel.cancellables.removeAll()
            dismiss()
          }
        }
        .store(in: &viewModel.cancellables)
    }
    .onDisappear {
        //삭제 이벤트 없이 Pop동작될때
        if !presentationMode.wrappedValue.isPresented {
          viewModel.cancellables.removeAll()
        }
    }
    ```    
## 4. 회고

![Untitled (1)](https://github.com/user-attachments/assets/5c278415-6a89-47ac-a419-885e4d4acf25)

1. 검색 결과를 보여줄 때 페이지네이션을 구현하여 성능 최적화를 하고 사용자 경험을 개선하고 싶었지만, 각각 다른 값이 입력된 요청에도 API에서는 같은 결과값만을 전달해주어 페이지네이션을 구현하지 못하였습니다. 차선택으로 한번에 많은 결과값을 보여주는 방법을 택하여 아쉬움이 남습니다. RestAPI의 특성상 결과 값은 개발자가 변화 시킬 수 없는 부분이기 때문에, 어떻게 하면 이 부분을 개발적으로 보완할 수 있을까 고민해 보아야 할 것 같습니다. 
