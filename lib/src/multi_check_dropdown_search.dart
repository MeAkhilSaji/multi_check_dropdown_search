library multi_check_dropdown_search;

import 'package:flutter/material.dart';

class MultiCheckDropdown extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final Function(List<Map<String, dynamic>>) onSelectionChanged;
  final double? width; // Custom width
  final String fieldKey; // Field key for display
  final List<Map<String, dynamic>>? initialSelectedItems; // Pre-selected items
  final String alias;
  final double? height;
  final TextStyle dropdownTextstyle;
  final TextStyle? noResultMessageStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? dropdownPlaceHolderStyle;

  final String columselectedText;
  final String hinttext;
  final Color backgroundColor;
  final Color backgroundColorSecond;
  bool shouldUpdate;
  final double? left;
  final double? top;
  final Color? activeCheckColor;
  final Color? unCheckColor;

  MultiCheckDropdown(
      {Key? key,
      required this.items,
      required this.onSelectionChanged,
      this.width,
      this.fieldKey = "label", // Default field key
      this.initialSelectedItems,
      this.alias = "label",
      required this.dropdownTextstyle,
      this.height,
      this.columselectedText = "items selected",
      this.hinttext = "Select items",
      this.shouldUpdate = false,
      required this.backgroundColor,
      this.backgroundColorSecond = const Color.fromARGB(255, 41, 40, 40),
      this.left,
      this.top,
      this.noResultMessageStyle,
      this.hintTextStyle,
      this.activeCheckColor,
      this.unCheckColor,
      this.dropdownPlaceHolderStyle})
      : super(key: key);

  @override
  _MultiCheckDropdownState createState() => _MultiCheckDropdownState();
}

class _MultiCheckDropdownState extends State<MultiCheckDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  late List<Map<String, dynamic>> _filteredItems;
  late List<Map<String, dynamic>> _selectedItems;
  bool _isDropdownOpen = false;
  bool _isSelectAllChecked = false;

  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    print("we calling it agiannnn");
    // Initialize with pre-selected items if provided
    _selectedItems = widget.initialSelectedItems != null
        ? List.from(widget.initialSelectedItems!)
        : [];

    // Update the "Select All" checkbox state
    _isSelectAllChecked = _selectedItems.length == widget.items.length;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    if (_overlayEntry != null && _isDropdownOpen) {
      _overlayEntry?.remove();
      _isDropdownOpen = false;
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MultiCheckDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Call `updateWhileCalling` only once when `shouldUpdate` is true
    if (widget.shouldUpdate) {
      updateWhileCalling();

      // Reset `shouldUpdate` after updating
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          widget.shouldUpdate = false;
        });
      });
    }
  }

  void updateWhileCalling() {
    setState(() {
      _filteredItems = widget.items;
      _selectedItems = widget.initialSelectedItems != null
          ? List.from(widget.initialSelectedItems!)
          : [];
      _isSelectAllChecked = _selectedItems.length == widget.items.length;
    });
  }

  void _filterItems(String query) {
    widget.shouldUpdate = false;
    setState(() {
      _filteredItems = widget.items
          .where((item) => item[widget.alias]
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  void _toggleSelection(Map<String, dynamic> item) {
    widget.shouldUpdate = false;
    bool mapExists = _selectedItems
        .any((map) => map[widget.fieldKey] == item[widget.fieldKey]);
    setState(() {
      if (mapExists) {
        _selectedItems.removeWhere(
            (map) => map[widget.fieldKey] == item[widget.fieldKey]);
      } else {
        _selectedItems.add(item);
      }

      _isSelectAllChecked = _selectedItems.length == widget.items.length;

      widget.onSelectionChanged(_selectedItems);
    });
  }

  void _toggleSelectAll(bool? isChecked) {
    widget.shouldUpdate = false;
    setState(() {
      _isSelectAllChecked = isChecked ?? false;

      if (_isSelectAllChecked) {
        _selectedItems = List.from(widget.items);
      } else {
        _selectedItems.clear();
      }

      widget.onSelectionChanged(_selectedItems);
    });
  }

  void _toggleDropdown() {
    widget.shouldUpdate = false;
    if (_isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    widget.shouldUpdate = false;
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context)?.insert(_overlayEntry!);
    setState(() {
      _isDropdownOpen = true;
    });
  }

  void _closeDropdown() {
    _overlayEntry?.remove();
    setState(() {
      _isDropdownOpen = false;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,

        onTap: _closeDropdown, // Close dropdown when tapping outside
        child: Stack(
          children: [
            Positioned(
              width: widget.width ?? size.width, // Use custom width if provided
              left: offset.dx,
              top: widget.height != null
                  ? offset.dy + widget.height!.toInt()
                  : offset.dy,
              child: Material(
                elevation: 9,
                child: Container(
                  color: widget.backgroundColorSecond,
                  child: Container(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: widget.backgroundColorSecond,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: StatefulBuilder(
                      builder: (context, setInnerState) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 12, right: 8),
                              child: Row(
                                children: [
                                  SizedBox(
                                    height: 12,
                                    width: 12,
                                    child: Checkbox(
                                      activeColor: widget.activeCheckColor ??
                                          Colors.blue,
                                      checkColor:
                                          widget.unCheckColor ?? Colors.white,
                                      value: _isSelectAllChecked,
                                      onChanged: (value) {
                                        setInnerState(() {
                                          _toggleSelectAll(value);
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 8),
                                      color: widget.backgroundColorSecond,
                                      child: TextField(
                                        style: widget.dropdownTextstyle
                                            .copyWith(color: Colors.white),
                                        decoration: InputDecoration(
                                          isDense: true,
                                          hintText: 'Serach Items',
                                          hintStyle: widget.hintTextStyle,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            borderSide: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                        ),
                                        onChanged: (value) {
                                          setInnerState(() {
                                            _filterItems(
                                                value); // Update search filter
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            _filteredItems.isEmpty
                                ? Text("No Result Found",
                                    style: widget.noResultMessageStyle)
                                : ConstrainedBox(
                                    constraints: BoxConstraints(maxHeight: 150),
                                    child: ListView.builder(
                                      padding:
                                          EdgeInsets.only(left: 4, right: 4),
                                      controller: _scrollController,
                                      itemCount: _filteredItems.length,
                                      itemBuilder: (context, index) {
                                        final item = _filteredItems[index];

                                        bool mapExists = _selectedItems.any(
                                            (map) =>
                                                map[widget.fieldKey] ==
                                                item[widget.fieldKey]);

                                        return Ink(
                                          child: Container(
                                            child: ListTile(
                                              trailing: SizedBox(),
                                              contentPadding:
                                                  EdgeInsets.only(left: 8),
                                              minLeadingWidth: 2,
                                              title: Container(
                                                  child: Text(
                                                item[widget.fieldKey]
                                                    .toString(),
                                                style: widget.dropdownTextstyle,
                                              )),
                                              leading: SizedBox(
                                                height: 12,
                                                width: 12,
                                                child: Checkbox(
                                                  activeColor:
                                                      widget.activeCheckColor ??
                                                          Colors.blue,
                                                  checkColor:
                                                      widget.unCheckColor ??
                                                          Colors.white,
                                                  value: mapExists,
                                                  onChanged: (value) {
                                                    setInnerState(() {
                                                      _toggleSelection(item);
                                                    });
                                                  },
                                                ),
                                              ),

                                              // trailing: trailing,
                                              dense: true,
                                              autofocus: true,

                                              visualDensity: VisualDensity
                                                  .adaptivePlatformDensity,

                                              // selectedColor: dropdownItemDecoration
                                              //         .selectedTextColor ??
                                              //     theme.colorScheme.onSurface,
                                              // textColor:
                                              //     dropdownItemDecoration.textColor ??
                                              //         theme.colorScheme.onSurface,
                                              // tileColor:
                                              //     tileColor ?? Colors.transparent,
                                              // selectedTileColor:
                                              //     dropdownItemDecoration
                                              //             .selectedBackgroundColor ??
                                              //         Colors.grey.shade200,
                                              onTap: () {
                                                setInnerState(() {
                                                  _toggleSelection(item);
                                                });
                                              },
                                            ),
                                          ),
                                        );
                                        return CheckboxListTile(
                                          value: mapExists,
                                          title: Text(
                                            item[widget.fieldKey].toString() +
                                                "dsf",
                                            style: widget.dropdownTextstyle
                                                .copyWith(color: Colors.white),
                                          ),
                                          activeColor: Colors.blue,
                                          checkColor: Colors.white,
                                          onChanged: (bool? isChecked) {
                                            setInnerState(() {
                                              _toggleSelection(item);
                                            });
                                          },
                                        );
                                      },
                                    ),
                                  ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          width: widget.width, // Custom width for the dropdown button
          height: widget.height ?? 50,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 6, right: 6),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5),
              color: widget.backgroundColor),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  _selectedItems.isNotEmpty
                      ? _selectedItems.length > 2
                          ? "${_selectedItems.length} ${" ${widget.columselectedText}"}"
                          : _selectedItems
                              .map((e) => e[widget.alias])
                              .join(", ")
                      : widget.hinttext,
                  style: widget.dropdownPlaceHolderStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Icon(
                color: Colors.white,
                size: 23,
                _isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
