import QtQuick 2.0
import Sailfish.Silica 1.0
import QtSparql 1.0

        AlphaMenuGroupView {

            property Component listDelegate: listDelegate
            property SparqlListModel dataSource: data

            id: alphaGroupView
            width: parent.width
            opacity: enabled ? 1 : 0
            dataModel: dataSource
            Behavior on opacity { FadeAnimation {} }

            delegate: listDelegate

            onActivated: {

                // If height is reduced, allow the exterior flickable to reposition itself
                if (newViewHeight > alphaGroupView.height) {
                    // Where should the list be positioned to show as much of the list as possible
                    // (but also show one row beyond the list if possible)
                    var maxVisiblePosition = alphaGroupView.y + viewSectionY + newListHeight + rowHeight - parent.height

                    // Ensure up to two rows of group elements to show at the top
                    var maxAllowedPosition = alphaGroupView.y + Math.max(viewSectionY - (1 * rowHeight), 0)

                    // Don't position beyond the end of the flickable
                    var totalContentHeight = alphaGroupView.height + newViewHeight
                    var maxContentY = root.originY + totalContentHeight - root.height

                    var newContentY = Math.max(Math.min(Math.min(maxVisiblePosition, maxAllowedPosition), maxContentY), 0)
                    if (newContentY > root.contentY) {
                        if (root._contentYBeforeGroupOpen < 0) {
                            root._contentYBeforeGroupOpen = root.contentY
                        }
                        root._animateContentY(newContentY, heightAnimationDuration, heightAnimationEasing)
                    }
                }
            }
            onDeactivated: {
                if (alphaGroupView.parent._contentYBeforeGroupOpen >= 0) {
                    alphaGroupView.parent._animateContentY(root._contentYBeforeGroupOpen, heightAnimationDuration, heightAnimationEasing)
                    alphaGroupView.parent._contentYBeforeGroupOpen = -1
                }
            }
        }



