@angular.module('arkh', [
    'ui.bootstrap'
    'ui.tinymce.inline'
    'xeditable'
    'angularSlideables'
    'restangular'
    'ngAnimate'
    'ngRoute'
    'angularFileUpload'
    ]
)
    .config(
        [
            'RestangularProvider' 
            (RestangularProvider) ->
                RestangularProvider.setRestangularFields
                    id: "_id"
                RestangularProvider.setBaseUrl '/api/v1'
        ]
    )
    .filter('markdown', ($sce) ->
        converter = new Showdown.converter()
        (value) ->
            html = converter.makeHtml(value || '')
            $sce.trustAsHtml(html)
    )
    .run (editableOptions) ->
        editableOptions.theme = 'bs3'

@TranslatedCtrl = ($scope, $http, $location, Restangular, $upload) ->
    s = $scope
    restng = Restangular
    Posts = restng.all('posts')
    
    s.posts = []
    s.postDefault = 
        background: []
    s.post = 
        background: []
    s.info = $location.url()
    s.dateNow = new Date()
    s.saveDisabled = false
    s.isNewPost = false
    
    s.onFileSelect = ($files) ->
        for file in $files
            console.log(file)
            s.upload = $upload.upload(
                url: '/post/upload',
                file: file,
            ).progress( (evt) ->
                console.log(evt.loaded)
            ).success( (data, status, headers, config) ->
                s.post.background.push(data)
            )
    
    s.getPosts = () ->
        Posts.getList().then (posts) ->
            s.posts = posts.reverse()
            s.setPost(0)
            
    s.setPost = (index) ->
        s.isNewPost = false
        s.post = s.posts[index]
    s.savePost = () ->
        if s.isNewPost
            Posts.post(s.post).then (posted) ->
                s.posts.push(posted)
        else
            s.post.put()
        s.saveDisabled = true
    s.newPost = () ->
        s.isNewPost = true
        s.post = 
            background: []
        s.post.posted = new Date()
    s.deletePost = () ->
        if confirm("Are you sure you want to delete this post?")
            if not s.isNewPost
                s.post.remove()
            s.getPosts(s.newPost)
        
    init = () ->
        s.getPosts()
        
    init()

@ModalCtrl = ($scope, $modal) ->
    $scope.items = {title: "Hi", body: "What?"}
    $scope.open = (title, body) ->
        $scope.items = {title: title, body: body}
        modalInstance = $modal.open
            templateUrl: "partials/modal"
            controller: ModalStanceCtrl
            resolve:
                items: () ->
                    $scope.items

@ModalStanceCtrl = ($scope, $modalInstance, items) ->
    $scope.items = items
    $scope.selected =
        item: $scope.items[0]
    
    $scope.ok = () ->
        $modalInstance.close $scope.selected.item 
    
    $scope.cancel = () ->
        $modalInstance.dismiss 'cancel'