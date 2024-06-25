//
//  Coordinator.swift
//  Foodit
//
//  Created by Woody on 6/23/24.
//
import NMapsMap
import SwiftUI

// - NMFMapViewCameraDelegate 카메라 이동에 필요한 델리게이트,
// - NMFMapViewTouchDelegate 맵 터치할 때 필요한 델리게이트,
// - CLLocationManagerDelegate 위치 관련해서 필요한 델리게이트

class Coordinator: NSObject, ObservableObject,
                         NMFMapViewCameraDelegate,
                         NMFMapViewTouchDelegate,
                         CLLocationManagerDelegate {
    static let shared = Coordinator()
    
    
    @Published var coord: (Double, Double) = (0.0, 0.0)
    @Published var userLocation: (Double, Double) = (0.0, 0.0)
    @Published var id: Int = 0
    @Published var isMapDetail: Bool = false
    
    // 사용자의 위치값은 CLLocationManager를 통해 받아준다.
    var locationManager: CLLocationManager?
    let startInfoWindow = NMFInfoWindow()
    
    let view = NMFNaverMapView(frame: .zero)
    
    override init() {
        super.init()
        
        view.mapView.positionMode = .direction
        view.mapView.isNightModeEnabled = true
        
        view.mapView.zoomLevel = 15 // 기본 맵이 표시될때 줌 레벨
        view.mapView.minZoomLevel = 1 // 최소 줌 레벨
        view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
        
        view.showLocationButton = true // 현위치 버튼: 위치 추적 모드를 표현합니다. 탭하면 모드가 변경됩니다.
        view.showZoomControls = true // 줌 버튼: 탭하면 지도의 줌 레벨을 1씩 증가 또는 감소합니다.
        view.showCompass = true //  나침반 : 카메라의 회전 및 틸트 상태를 표현합니다. 탭하면 카메라의 헤딩과 틸트가 0으로 초기화됩니다. 헤딩과 틸트가 0이 되면 자동으로 사라집니다
        view.showScaleBar = true // 스케일 바 : 지도의 축척을 표현합니다. 지도를 조작하는 기능은 없습니다.
        
        view.mapView.addCameraDelegate(delegate: self)
        view.mapView.touchDelegate = self
        checkLocationAuthorization()
        
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        // 카메라 이동이 시작되기 전 호출되는 함수
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        // 카메라의 위치가 변경되면 호출되는 함수
        
    }
    
    
    
    // MARK: - 위치 정보 동의 확인
    
    /*
     ContetView 에서 .onAppear 에서 위치 정보 제공을 동의 했는지 확인하는 함수를 호출한다.
     위치 정보 제공 동의 순서
     1. MapView에서 .onAppear에서 checkIfLocationServiceIsEnabled() 호출
     2. checkIfLocationServiceIsEnabled() 함수 안에서 locationServicesEnabled() 값이 true인지 체크
     3. true일 경우(동의한 경우), checkLocationAuthorization() 호출
     4. case .authorizedAlways(항상 허용), .authorizedWhenInUse(앱 사용중에만 허용) 일 경우에만 fetchUserLocation() 호출
     */

    // 2. locationServicesEnabled()가 true일 때만 들어온다? 이상한데...?
    func checkLocationAuthorization() {
        guard let locationManager = locationManager else { return }
        print(locationManager)
        
        switch locationManager.authorizationStatus {
            
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            // naver danymic map test 해본 결과 사용량 1번 밖에 증가하지 않아서 이대로 사용 해도 될 것 같음
            checkLocationAuthorization()
            print("not yet")
        case .restricted:
            print("위치 정보 접근이 제한되었습니다.")
        case .denied:
            print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
        case .authorizedAlways, .authorizedWhenInUse:
            print("sccuecced")
            coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
            
            // 3. 위치 접근에 동의했을 때만 접근
            fetchUserLocation()

        @unknown default:
            break
        }
    } // checkLocationAuthorization()
    
    // 1. MapView의 .onAppear()로 실행
    func checkIfLocationServiceIsEnabled() {
        DispatchQueue.global().async {
            // locationServicesEnabled true of false
            if CLLocationManager.locationServicesEnabled() {
                DispatchQueue.main.async {
                    self.locationManager = CLLocationManager()
                    self.locationManager!.delegate = self
//                    self.locationManager!.requestWhenInUseAuthorization()
                    self.checkLocationAuthorization()
                }
            } else {
                print("Show an alert letting them know this is off and to go turn i on")
            }
        } // DispatchQueue
    } // checkIfLocationServiceIsEnabled()
    
    // MARK: - NMFMapView에서 제공하는 locationOverlay를 현재 위치로 설정
    func fetchUserLocation() {
        if let locationManager = locationManager {
            let lat = locationManager.location?.coordinate.latitude
            let lng = locationManager.location?.coordinate.longitude
            
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0), zoomTo: 15)
            cameraUpdate.animation = .easeIn
            cameraUpdate.animationDuration = 1
            
            let locationOverlay = view.mapView.locationOverlay
            locationOverlay.location = NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0)
            locationOverlay.hidden = false
            
            locationOverlay.icon = NMFOverlayImage(name: "location_overlay_icon")
            locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
            locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
            locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
            
            // 지도를 사용자 위치로 이동
            view.mapView.moveCamera(cameraUpdate)
        } // if
    } // fetchUserLocation()
    
    // MARK: user가 search Input을 onSubmit 했을 때
    func userSearchInputOnSubmitted(){
        print("when user inputs search")

        let lat = userLocation.0
        let lng = userLocation.1
        
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat, lng: lng), zoomTo: 15)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        
        let locationOverlay = view.mapView.locationOverlay
        locationOverlay.location = NMGLatLng(lat: lat, lng: lng)
        locationOverlay.hidden = false
    
        locationOverlay.icon = NMFOverlayImage(name: "location_overlay_icon")
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
    
        // 지도를 사용자 위치로 이동
        view.mapView.moveCamera(cameraUpdate)
    } // userSearchInputOnSubmitted()
    
    func getNaverMapView() -> NMFNaverMapView {
        view
    } // getNaverMapView()
    
    // 마커 부분의 lat lng를 init 부분에 호출해서 사용하면 바로 사용가능하지만
    // 파이어베이스 연동의 문제를 생각해서 받아오도록 만들었습니다.
    // MARK: for 마커
    func setMarker(postList: [Post]){
//        print(postList)
//        lat : Double, lng:Double
        
        for post in postList{
            // 마커 instance 생성
            let marker = NMFMarker()
            
            // 마커 색상
            if post.category == "음식" {
                marker.iconImage = NMFOverlayImage(name: "food")
            }else if post.category == "커피" {
                marker.iconImage = NMFOverlayImage(name: "coffee")
            }else{
                marker.iconImage = NMFOverlayImage(name: "bakery")
            }        
            
            // 마커 좌표
            marker.position = NMGLatLng(lat: post.lat, lng: post.lng)
            
            // 마커 size 설정
            marker.width = 25
            marker.height = 40
            marker.mapView = view.mapView
            
            let infoWindow = NMFInfoWindow()
            let dataSource = NMFInfoWindowDefaultTextSource.data()
            
            // 마커를 탭하면:
            let handler = {(overlay: NMFOverlay) -> Bool in
                if let marker = overlay as? NMFMarker {
                    if marker.infoWindow == nil {
                        self.id = post.id
                        self.isMapDetail = true
                        // 현재 마커에 정보 창이 열려있지 않을 경우 엶
//                        dataSource.title = post.name
//                        infoWindow.dataSource = dataSource
//                        infoWindow.open(with: marker)
                    } 
//                    else {
//                        // 이미 현재 마커에 정보 창이 열려있을 경우 닫음
////                        infoWindow.close()
//
//                    }
                }
                return true
            }
            marker.touchHandler = handler
        } // for
    } // setMarker()
    
}
