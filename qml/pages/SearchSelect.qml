import QtQuick 2.0
import Sailfish.Silica 1.0

    SilicaListView {
        id: searchPage
        property bool keepSearchFieldFocus
        property string activeView: "list"
        property string searchString
        onSearchStringChanged: listModel.update()


        model: ListModel {
            id: listModel

            property variant countries: ["Afghanistan", "Albania", "Algeria", "Andorra", "Angola",
                "Antigua and Barbuda", "Argentina", "Armenia", "Australia", "Austria",
                "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados",
                "Belarus", "Belgium", "Belize", "Benin", "Bhutan",
                "Bolivia", "Bosnia and Herzegovina", "Botswana", "Brazil", "Brunei",
                "Bulgaria", "Burkina Faso", "Burma", "Burundi", "Cambodia",
                "Cameroon", "Canada", "Cape Verde", "Central African Republic", "Chad",
                "Chile", "China", "Colombia", "Comoros", "Costa Rica",
                "Croatia", "Cuba", "Cyprus", "Czech Republic", "Denmark",
                "Djibouti", "Dominica", "Dominican Republic", "East Timor", "Ecuador",
                "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia",
                "Ethiopia", "Fiji", "Finland", "France", "Gabon",
                "Gambia", "Georgia", "Germany", "Ghana", "Greece",
                "Grenada", "Guatemala", "Guinea", "Guinea-Bissau", "Guyana",
                "Haiti", "Honduras", "Hungary", "Iceland", "India",
                "Indonesia", "Iran", "Iraq", "Ireland", "Israel",
                "Italy", "Jamaica", "Japan", "Jordan", "Kazakhstan",
                "Kenya", "Kiribati", "Korea North", "Korea South", "Kuwait",
                "Kyrgyzstan", "Laos", "Latvia", "Lebanon", "Lesotho",
                "Liberia", "Libya", "Liechtenstein", "Lithuania", "Luxembourg",
                "Macedonia", "Madagascar", "Malawi", "Malaysia", "Maldives",
                "Mali", "Malta", "Marshall Islands", "Mauritania", "Mauritius",
                "Mexico", "Micronesia", "Moldova", "Monaco", "Mongolia",
                "Montenegro", "Morocco", "Mozambique", "Namibia", "Nauru",
                "Nepal", "Netherlands", "New Zealand", "Nicaragua", "Niger",
                "Nigeria", "Norway", "Oman", "Pakistan", "Palau",
                "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines",
                "Poland", "Portugal", "Qatar", "Romania", "Russia",
                "Rwanda", "Saint Kitts and Nevis", "Saint Lucia", "Saint Vincent and the Grenadines", "Samoa",
                "San Marino", "Saudi Arabia", "Senegal", "Serbia", "Seychelles",
                "Sierra Leone", "Singapore", "Slovakia", "Slovenia", "Solomon Islands",
                "Somalia", "South Africa", "South Sudan", "Spain", "Sri Lanka",
                "Sudan", "Suriname", "Swaziland", "Sweden", "Switzerland",
                "Syria", "Tajikistan", "Tanzania", "Thailand", "Togo",
                "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan",
                "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom",
                "United States", "Uruguay", "Uzbekistan", "Vanuatu", "Vatican City",
                "Venezuela", "Vietnam", "Yemen", "Zambia", "Zimbabwe",
                "Abkhazia", "Cook Islands", "Kosovo", "Nagorno-Karabakh", "Niue",
                "Northern Cyprus", "Palestine", "SADR", "Somaliland", "South Ossetia",
                "Taiwan"]

            function update() {
                var filteredCountries = countries.filter(function (country) { return country.toLowerCase().indexOf(searchString) !== -1 })
                while (count > filteredCountries.length) {
                    remove(filteredCountries.length)
                }
                for (var index = 0; index < filteredCountries.length; index++) {
                    if (index < count) {
                        setProperty(index, "text", filteredCountries[index])
                    } else {
                        append({ "text": filteredCountries[index]})
                    }
                }
            }
        }
        anchors.fill: parent
        currentIndex: -1 // otherwise currentItem will steal focus
        header: SearchField {
            id: searchField
            width: parent.width

            Binding {
                target: searchPage
                property: "searchString"
                value: searchField.text.toLowerCase().trim()
            }
        }

        delegate: BackgroundItem {
            id: backgroundItem

            ListView.onAdd: AddAnimation {
                target: backgroundItem
            }
            ListView.onRemove: RemoveAnimation {
                target: backgroundItem
            }

            Label {
                x: searchField.textLeftMargin
                anchors.verticalCenter: parent.verticalCenter
                color: searchString.length > 0 ? (highlighted ? Theme.secondaryHighlightColor : Theme.secondaryColor)
                                               : (highlighted ? Theme.highlightColor : Theme.primaryColor)
                textFormat: Text.StyledText
                text: Theme.highlightText(model.text, searchString, Theme.highlightColor)
            }
        }

        VerticalScrollDecorator {}

        Component.onCompleted: {
            if (keepSearchFieldFocus) {
                searchField.forceActiveFocus()
            }
            keepSearchFieldFocus = false
            listModel.update()
        }
    }
