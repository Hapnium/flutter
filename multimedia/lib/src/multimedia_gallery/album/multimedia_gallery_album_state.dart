part of 'multimedia_gallery_album.dart';

class _MultimediaGalleryAlbumState extends State<MultimediaGalleryAlbum> {
  bool _isGrid = true;
  List<Medium> _mediums = <Medium>[];
  List<Medium> _selected = [];
  int _gridCount = 2;
  String _selectedGrid = "";
  bool _isFetching = true;
  late MultimediaGalleryAlbumConfiguration parent;

  @override
  void initState() {
    parent = widget.configuration;
    _fetch();
    _onGridChanged(grids[0].header);

    super.initState();
  }

  void _fetch() async {
    MediaPage page = await widget.album.listMedia();
    setState(() {
      _mediums = page.items;
      _isFetching = false;
    });
  }

  @override
  void didUpdateWidget(covariant MultimediaGalleryAlbum oldWidget) {
    if(oldWidget.album.notEquals(widget.album) || oldWidget.multipleAllowed.notEquals(widget.multipleAllowed)) {
      setState(() { });
    }

    if(oldWidget.configuration != widget.configuration) {
      setState(() {
        parent = widget.configuration;
      });
    }

    super.didUpdateWidget(oldWidget);
  }

  @protected
  List<ButtonView> get grids => (parent.grids ?? ["2x", "3x"]).asMap().entries.map((MapEntry<int, String> item) {
    return ButtonView(header: item.value, index: item.key);
  }).toList();

  @protected
  bool get multipleAllowed => widget.multipleAllowed;

  @protected
  List<String> get selectedIds => _selected.map((m) => m.id).toSet().toList();

  @protected
  AlbumViewConfiguration get configuration => parent.configuration ?? AlbumViewConfiguration();

  @protected
  MultimediaIconConfiguration get iconConfig => parent.iconConfiguration ?? MultimediaIconConfiguration();

  @protected
  MultimediaLayoutConfiguration get layoutConfig => parent.layoutConfiguration ?? MultimediaLayoutConfiguration();

  @protected
  MultimediaNoItemConfiguration get noItemConfig => parent.noItemConfiguration ?? MultimediaNoItemConfiguration();

  @protected
  MultimediaGridFilterConfiguration get gridFilterConfig => parent.gridFilterConfiguration ?? MultimediaGridFilterConfiguration();

  @protected
  MultimediaDoneButtonConfiguration get doneButtonConfig => parent.doneButtonConfiguration ?? MultimediaDoneButtonConfiguration();

  void _onCompleted() => _send(_selected);

  void _send(List<Medium> selected) {
    if(widget.onMediumReceived.isNotNull) {
      widget.onMediumReceived!(selected);
    } else if(parent.popAllWhileGoingBack) {
      // First pop returns to the album page
      Navigator.pop(context);
      // Delay the second pop until the current pop completes
      Future.delayed(Duration.zero, () {
        Navigator.pop(context, selected); // Pop album page with result
      });
    } else {
      Navigator.pop(context, selected);
    }
  }

  void _onLayoutChanged() {
    setState(() => _isGrid = !_isGrid);

    if(parent.onLayoutChanged.isNotNull) {
      parent.onLayoutChanged!(_isGrid);
    }
  }

  void _onGridChanged(String value) {
    final match = RegExp(r'\d+').firstMatch(value);
    if(match != null) {
      final grid = int.parse(match.group(0)!);

      setState(() {
        _gridCount = grid;
        _selectedGrid = value;
      });
    } else {
      setState(() {
        _gridCount = 2;
      });
    }

    if(parent.onGridChanged.isNotNull) {
      parent.onGridChanged!(_gridCount);
    }
  }

  void _handleSelectedMedium(Medium medium) {
    if(multipleAllowed) {
      List<Medium> list = List.from(_selected);
      int index = list.findIndex((i) => i.id.equals(medium.id));
      if(index.equals(-1)) {
        list.add(medium);
      } else {
        list.removeAt(index);
      }

      setState(() {
        _selected = list;
      });
    } else {
      _send([medium]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewLayout(
      config: layoutConfig.config,
      extendBehindAppbar: layoutConfig.extendBehindAppbar,
      extendBody: layoutConfig.extendBody,
      goDark: layoutConfig.goDark,
      theme: layoutConfig.theme,
      shouldWillPop: layoutConfig.shouldWillPop,
      shouldOverride: layoutConfig.shouldOverride,
      floatingButton: layoutConfig.floatingButton,
      floater: layoutConfig.floater,
      floaterWidth: layoutConfig.floaterWidth,
      floatingLocation: layoutConfig.floatingLocation,
      drawer: layoutConfig.drawer,
      endDrawer: layoutConfig.endDrawer,
      needSafeArea: layoutConfig.needSafeArea,
      useFloaterWidth: layoutConfig.useFloaterWidth,
      withActivity: layoutConfig.withActivity,
      onInactivity: layoutConfig.onInactivity,
      onActivity: layoutConfig.onActivity,
      inactivityDuration: layoutConfig.inactivityDuration,
      isLoading: layoutConfig.isLoading,
      loadingHeight: layoutConfig.loadingHeight,
      loadingPosition: layoutConfig.loadingPosition,
      loadingWidth: layoutConfig.loadingWidth,
      loadingColor: layoutConfig.loadingColor,
      loadingBackgroundColor: layoutConfig.loadingBackgroundColor,
      floatFit: layoutConfig.floatFit,
      loadingFit: layoutConfig.loadingFit,
      bottomNavbar: layoutConfig.bottomNavbar,
      bottomSheet: layoutConfig.bottomSheet,
      barColor: layoutConfig.barColor,
      navigationColor: layoutConfig.navigationColor,
      darkBackgroundColor: layoutConfig.darkBackgroundColor,
      onWillPop: layoutConfig.onWillPop,
      backgroundColor: layoutConfig.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      appbar: AppBar(
        elevation: parent.appBarElevation ?? 0.5,
        title: parent.titleWidget ?? TextBuilder.center(
          text: ("${widget.album.name ?? "Unnamed Album"} (${widget.album.count.toString()})").capitalizeEach,
          size: parent.titleSize ?? Sizing.font(20),
          weight: parent.titleWeight ?? FontWeight.bold,
          color: parent.titleColor ?? Theme.of(context).primaryColor
        ),
        actions: [
          if(selectedIds.isNotEmpty) ...[
            TextButton(
              onPressed: _onCompleted,
              style: ButtonStyle(
                overlayColor: WidgetStatePropertyAll(doneButtonConfig.overlayColor ?? Colors.transparent),
                backgroundColor: WidgetStateProperty.all(doneButtonConfig.backgroundColor ?? Colors.transparent),
                foregroundColor: WidgetStateProperty.all(doneButtonConfig.foregroundColor ?? Colors.transparent),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                shape: WidgetStateProperty.all(doneButtonConfig.shape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
                padding: WidgetStateProperty.all(doneButtonConfig.padding ?? EdgeInsets.symmetric(horizontal: 6))
              ),
              child: TextBuilder(
                text: doneButtonConfig.text ?? "Done",
                weight: doneButtonConfig.fontWeight ?? FontWeight.bold,
                color: doneButtonConfig.color ?? Colors.black
              )
            ),
          ],
          InfoButton(
            onPressed: _onLayoutChanged,
            defaultIcon: _isGrid ? (iconConfig.grid ?? Icons.grid_view_rounded) : (iconConfig.list ?? Icons.format_list_bulleted_outlined),
            defaultIconColor: iconConfig.color ?? Theme.of(context).primaryColor,
            defaultIconSize: iconConfig.size ?? Sizing.font(20),
          )
        ],
      ),
      child: _build()
    );
  }

  Widget _build() {
    if(_isFetching) {
      return parent.loadingBuilder.isNotNull ? parent.loadingBuilder!(context) : Center(
        child: CircularProgressIndicator(color: parent.loadingColor ?? Theme.of(context).primaryColor)
      );
    } else if(_mediums.isEmpty) {
      return parent.emptyBuilder.isNotNull ? parent.emptyBuilder!(context) : NoItemFoundIndicator(
        message: noItemConfig.message ?? "No media found in this album",
        icon: noItemConfig.icon ?? Icons.photo_library_rounded,
        textColor: noItemConfig.textColor ?? Theme.of(context).primaryColor,
        iconSize: noItemConfig.iconSize ?? Sizing.font(100),
        textSize: noItemConfig.textSize ?? Sizing.font(16),
        spacing: noItemConfig.spacing ?? 10,
        opacity: noItemConfig.opacity ?? 0.2,
        customIcon: noItemConfig.iconWidget,
      );
    } else if(_isGrid) {
      return Column(
        spacing: parent.gridViewSpacing ?? 4,
        mainAxisAlignment: parent.gridViewMainAlignment ?? MainAxisAlignment.start,
        mainAxisSize: parent.gridViewMainAxisSize ?? MainAxisSize.max,
        crossAxisAlignment: parent.gridViewCrossAlignment ?? CrossAxisAlignment.start,
        children: [
          if(parent.showFilters) ...[
            Padding(padding: gridFilterConfig.padding ?? const EdgeInsets.all(10.0), child: _buildFilters(context)),
          ],
          Expanded(
            child: AlbumGridView(
              mediums: _mediums,
              onSelected: _handleSelectedMedium,
              count: _gridCount,
              selected: selectedIds,
              configuration: configuration
            )
          )
        ]
      );
    } else {
      return AlbumListView(
        mediums: _mediums,
        onSelected: _handleSelectedMedium,
        selected: selectedIds,
        configuration: configuration
      );
    }
  }

  Widget _buildFilters(BuildContext context) {
    return Wrap(
      runAlignment: gridFilterConfig.runAlignment ?? WrapAlignment.spaceBetween,
      crossAxisAlignment: gridFilterConfig.crossAlignment ?? WrapCrossAlignment.center,
      spacing: gridFilterConfig.spacing ?? 5,
      runSpacing: gridFilterConfig.runSpacing ?? 5,
      children: grids.map((view) {
        final bool isSelected = view.header.equals(_selectedGrid);

        final Color baseColor = gridFilterConfig.buttonColor ?? Colors.amber;
        final Color bgColor = isSelected ? baseColor.lighten(45) : baseColor.lighten(90);
        final Color txtColor = isSelected ? baseColor : baseColor.lighten(30);

        return TextButton(
          onPressed: () => _onGridChanged(view.header),
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(bgColor),
            overlayColor: WidgetStatePropertyAll(baseColor.lighten(60)),
            padding: WidgetStateProperty.all(gridFilterConfig.buttonPadding ?? EdgeInsets.symmetric(horizontal: 6)),
            shape: WidgetStateProperty.all(gridFilterConfig.buttonShape ?? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: TextBuilder(
            text: view.header,
            size: Sizing.font(gridFilterConfig.buttonTextSize ?? 11),
            color: txtColor,
          )
        );
      }).toList(),
    );
  }
}