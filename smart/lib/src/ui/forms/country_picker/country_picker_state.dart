part of 'country_picker.dart';

class _CountryPickerState extends State<CountryPicker> {
  late List<Country> _filteredCountries;
  Country? _selectedCountry;

  @override
  void initState() {
    _selectedCountry = widget.selected;
    _filteredCountries = widget.countries.isEmpty ? CountryData.instance.countries : widget.countries;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isDialog) {
      return _buildWithDialog(context);
    } else {
      return _buildWithBottomSheet(context);
    }
  }

  /// Dialog option
  Widget _buildWithDialog(BuildContext context) {
    return Dialog(
      insetPadding: widget.dialogPadding ?? EdgeInsets.symmetric(
        vertical: Sizing.space(40),
        horizontal: Sizing.space(20)
      ),
      shape: widget.dialogShape,
      insetAnimationDuration: widget.dialogAnimationDuration ?? const Duration(milliseconds: 100),
      insetAnimationCurve: widget.dialogAnimationCurve ?? Curves.decelerate,
      backgroundColor: widget.backgroundColor ?? Theme.of(context).splashColor,
      surfaceTintColor: widget.surfaceTintColor ?? Theme.of(context).splashColor,
      child: Container(
        padding: widget.bodyPadding ?? EdgeInsets.all(Sizing.space(10)),
        child: Column(
          spacing: widget.bodySpacing ?? 20,
          mainAxisSize: widget.mainAxisSize ?? MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if(widget.indicator.isNotNull) ...[
              widget.indicator!
            ],
            if(widget.showSearchFormField) ...[
              _buildSearchFormField(),
            ],
            _buildCountryListView(context)
          ],
        ),
      ),
    );
  }

  Widget _buildSearchFormField() {
    if(widget.searchFormFieldBuilder.isNotNull) {
      return widget.searchFormFieldBuilder!(_search);
    }

    return Field(
      hint: widget.placeholder ?? "Search Country/Region",
      borderRadius: widget.formBorderRadius ?? Sizing.space(20),
      suffixIcon: widget.icon ?? Icon(Icons.search),
      inputConfigBuilder: widget.inputConfigBuilder,
      inputDecorationBuilder: widget.decorationConfigBuilder,
      onChanged: _search,
      fillColor: widget.formBackgroundColor,
    );
  }

  void _search(String value) {
    _filteredCountries = value.isNumeric
      ? widget.countries.where((country) => country.dialCode.contains(value)).toList()
      : widget.countries.where((country) => country.name.equalsIgnoreCase(value)).toList();

    if (mounted) setState(() {});
  }

  Widget _buildCountryListView(BuildContext context) {
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: _filteredCountries.length,
        separatorBuilder: (context, index) {
          Country country = _filteredCountries[index];

          ItemMetadata<Country> metadata = ItemMetadata(
            isSelected: country.name.equalsIgnoreCase(_selectedCountry?.name ?? ""),
            isLast: index.equals(_filteredCountries.length - 1),
            isFirst: index.equals(0),
            index: index,
            totalItems: _filteredCountries.length,
            item: country
          );

          if(widget.itemSeparatorBuilder.isNotNull) {
            return widget.itemSeparatorBuilder!(context, metadata);
          }

          return Spacing.vertical(widget.itemSeparatorSize ?? 10);
        },
        itemBuilder: (ctx, index) {
          Country country = _filteredCountries[index];

          ItemMetadata<Country> metadata = ItemMetadata(
            isSelected: country.name.equalsIgnoreCase(_selectedCountry?.name ?? ""),
            isLast: index.equals(_filteredCountries.length - 1),
            isFirst: index.equals(0),
            index: index,
            totalItems: _filteredCountries.length,
            item: country
          );

          if(widget.itemBuilder.isNotNull) {
            return widget.itemBuilder!(context, metadata);
          }

          return SmartButton(
            tab: ButtonView(
              header: country.name,
              body: '+${country.dialCode}',
              imageWidget: CountryUtil.instance.getFlag(
                country,
                useFlagEmoji: widget.useFlagEmoji,
                size: widget.itemFlagSize
              )
            ),
            headerTextSize: widget.itemNameSize,
            bodyTextSize: widget.itemDialCodeSize,
            color: widget.itemNameColor,
            bodyColor: widget.itemDialCodeColor,
            fontWeight: widget.itemNameWeight,
            bodyWeight: widget.itemDialCodeWeight,
            backgroundColor: widget.itemBackgroundColor,
            notification: TextBuilder(
              text: country.code,
              size: Sizing.font(widget.itemCodeSize ?? 20),
              weight: widget.itemCodeWeight ?? FontWeight.w700,
              color: widget.itemCodeColor ?? Theme.of(context).primaryColor
            ),
            onTap: () {
              _selectedCountry = country;

              setState(() {});

              if(widget.onChanged.isNotNull) {
                widget.onChanged!(country);
              }

              Navigator.of(context).pop(country);

              /// Making an extra onChanged call here for method safety after `Navigator.pop` has been called.
              if(widget.onChanged.isNotNull) {
                widget.onChanged!(country);
              }
            },
          );
        }
      ),
    );
  }

  Widget _buildWithBottomSheet(BuildContext context) {
    return ModalBottomSheet(
      useSafeArea: (config) => config.copyWith(top: true),
      sheetPadding: widget.dialogPadding ?? EdgeInsets.all(16),
      padding: widget.bodyPadding ?? EdgeInsets.all(10),
      borderRadius: widget.bottomSheetBorderRadius ?? BorderRadius.circular(24),
      backgroundColor: widget.backgroundColor ?? Theme.of(context).splashColor,
      height: widget.height,
      uiConfig: widget.uiConfig,
      useDefaultBorderRadius: widget.useDefaultBorderRadius,
      child: Column(
        spacing: widget.bodySpacing ?? 20,
        mainAxisSize: widget.mainAxisSize ?? MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if(widget.indicator.isNotNull) ...[
            widget.indicator!
          ],
          if(widget.showSearchFormField) ...[
            _buildSearchFormField(),
          ],
          _buildCountryListView(context)
        ],
      ),
    );
  }
}
