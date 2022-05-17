//*********************** -- HISTORY -- ******************************
// FileName: XmlValidationException.cs
// Author : Saravana Kumar
// Purpose: This file contains three important classes:
//          1. XmlValidationException derived from System.Exception, which will be thrown to the calling application.
//          2. XmlValidationErrorType which contains the error detail (Nodename, severity and description), and
//          3. XmlValidationErrors is a collection object containing collection of XmlValidationErrorType. 
//          Whenever the incoming message fails validations, a consolidated collection of errors will be wrapped and thrown as XmlValidationException
//********************************************************************
using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Runtime.Serialization;

namespace DDL.PipelineComponents
{
    /// <summary>
    /// XmlValidationException. Contains all the schema validation errors.
    /// </summary>
    /// 
    [Serializable()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://www.digitaldeposit.net/pipelineComponent/XmlValidation")]
    [System.Xml.Serialization.XmlRootAttribute("XmlValidationException", Namespace = "http://www.digitaldeposit.net/pipelineComponent/XmlValidation", IsNullable = false)]
    public class XmlValidationException : System.Exception
    {
        private XmlValidationErrors _errorCollection;
        private string _errorCode;

        public string ErrorCode
        {
            get { return _errorCode; }
            set { _errorCode = value; }
        }

        public XmlValidationErrors ErrorCollection
        {
            get
            {
                return _errorCollection;
            }
            set
            {
                _errorCollection = value;
            }
        }

        public override string ToString()
        {
            return ConsolidatedErrors();
        }
        public override string Message
        {
            get
            {
                return base.Message + ConsolidatedErrors();
            }
        }
        private string ConsolidatedErrors()
        {
            string errorDesc = string.Empty;
            foreach (XmlValidationErrorType error in ErrorCollection)
            {
                errorDesc += "NodeName: " + error.nodeName + "NodeValue: " + error.nodeValue + " NodeNameSpace: " + error.nodeNameSpace + ". Severity: " + error.severity + ". Description: " + error.description + ". " + System.Environment.NewLine;
            }

            return errorDesc;
        }

        protected void Initialize()
        {
            _errorCode = string.Empty;
            _errorCollection = new XmlValidationErrors();
        }

        //Constructor
        public XmlValidationException()
            : base()
        {
            System.Diagnostics.Debug.WriteLine("V 1.0");
            Initialize();
        }
        public XmlValidationException(string Message)
            : base(Message)
        {
            Initialize();
        }
        public XmlValidationException(string Message, Exception Inner)
            : base(Message, Inner)
        {
            Initialize();
        }
        public XmlValidationException(string Message, string ErrorCode, Exception Inner)
            : base(Message, Inner)
        {
            _errorCode = ErrorCode;
            Initialize();
        }
        // SERIALIZATION SUPPORT
        protected XmlValidationException(SerializationInfo info, StreamingContext context)
            : base(info, context)
        {
            _errorCode = info.GetString("errorCode");
            _errorCollection = (XmlValidationErrors)info.GetValue("errorCollection",typeof(XmlValidationErrors));
        }
        public override void GetObjectData(SerializationInfo info, StreamingContext context)
        {
            info.AddValue("errorCode", _errorCode);
            info.AddValue("errorCollection", _errorCollection);
            base.GetObjectData(info, context);
        }
    }

    [Serializable()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://www.digitaldeposit.net/pipelineComponent/XmlValidation")]
    [System.Xml.Serialization.XmlRootAttribute("XmlValidationErrorType", Namespace = "http://www.digitaldeposit.net/pipelineComponent/XmlValidation", IsNullable = false)]
    public class XmlValidationErrorType
    {
        public XmlValidationErrorType()
        { }

        string _description;

        public string description
        {
            get { return _description; }
            set { _description = value; }
        }

        string _nodeName;

        public string nodeName
        {
            get { return _nodeName; }
            set { _nodeName = value; }
        }
        string _severity;

        public string severity
        {
            get { return _severity; }
            set { _severity = value; }
        }

        string _nodeValue;

        public string nodeValue
        {
            get { return _nodeValue; }
            set { _nodeValue = value; }
        }

        string _nodeNameSpace;

        public string nodeNameSpace
        {
            get { return _nodeNameSpace; }
            set { _nodeNameSpace = value; }
        }

        public enum ErrorType
        { 
            Structural,
            Pattern
        }
        ErrorType _errorType;

        public ErrorType errorType
        {
            get { return _errorType; }
            set { _errorType = value; }
        }
    }

    [Serializable()]
    [System.Xml.Serialization.XmlTypeAttribute(Namespace = "http://www.digitaldeposit.net/pipelineComponent/XmlValidation")]
    [System.Xml.Serialization.XmlRootAttribute("XmlValidationErrors", Namespace = "http://www.digitaldeposit.net/pipelineComponent/XmlValidation", IsNullable = false)]
    public class XmlValidationErrors : CollectionBase
    {
        public XmlValidationErrors()
        { }

        public XmlValidationErrorType this[int index]
        {
            get
            {
                return ((XmlValidationErrorType)List[index]);
            }
            set
            {
                List[index] = value;
            }
        }

        public int Add(XmlValidationErrorType value)
        {
            return (List.Add(value));
        }

        public int IndexOf(XmlValidationErrorType value)
        {
            return (List.IndexOf(value));
        }

        public void Insert(int index, XmlValidationErrorType value)
        {
            List.Insert(index, value);
        }

        public void Remove(XmlValidationErrorType value)
        {
            List.Remove(value);
        }

        public bool Contains(XmlValidationErrorType value)
        {
            // If value is not of type XmlValidationErrorType, this will return false.
            return (List.Contains(value));
        }

        protected override void OnInsert(int index, Object value)
        {
            // Insert additional code to be run only when inserting values.
        }

        protected override void OnRemove(int index, Object value)
        {
            // Insert additional code to be run only when removing values.
        }

        protected override void OnSet(int index, Object oldValue, Object newValue)
        {
            // Insert additional code to be run only when setting values.
        }

        protected override void OnValidate(Object value)
        {
            if (value.GetType().Name != "XmlValidationErrorType")
                throw new ArgumentException("value must be of type XmlValidationErrorType.", "value");
        }

    }
}
